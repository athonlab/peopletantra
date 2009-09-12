import re
from BeautifulSoup import BeautifulSoup, Tag, NavigableString
import urllib
from MySQLdb import connect
from datetime import datetime, date
connection = connect('localhost', 'root', 'qsedwa123', 'pt_development')
connection.autocommit(True)
cursor = connection.cursor()

class Parser:
    @classmethod
    def extract_loksabha_mp_codes_from_listing(klass, data):
        soup = BeautifulSoup(data)
        return [elem['href'].split('=')[1] for elem in soup.findAll(href=re.compile('^loksabhampdetail'))]

    @classmethod
    def extract_rajyasabha_mp_codes_from_listing(klass, data):
        soup = BeautifulSoup(data)
        return [elem['href'].split('=')[1] for elem in soup.findAll(href=re.compile('^rajyasabhampdetail'))]

    @staticmethod
    def extract_member(data):
        soup = BeautifulSoup(data)
        member = {}
        for strong in soup.findAll('strong'):
            if strong.string != 'Detailed Profile':
                member[strong.string] = " ".join([content for content in strong.parent.nextSibling.contents if type(content) == NavigableString] )
        return member

def clean_loksabha_member(member):
    ''' All the preprocessing of data be done here '''
    son_daughter = {}
    for key in member:
        member[key] = connection.escape_string(member[key].strip())
        if key in ('Date of Birth', 'Date of Marriage'):
            try:
                member[key] = datetime.strptime( member[key], '%Y-%m-%d')
                member[key] = date(member[key].year, member[key].month, member[key].day)
            except:
                member[key] = None
        elif key == 'No. of Children':
            colon_split = member[key].split(':')
            try:
                son_daughter['No of Daughters'] = int(colon_split[-1])
                son_daughter['No of Sons'] = int(colon_split[1].split('&nbsp;')[0])
            except:
                son_daughter['No of Daughters'] = 0
                son_daughter['No of Sons'] = 0
            member[key] = son_daughter["No of Daughters"] + son_daughter['No of Sons']
        elif key == 'Maritial Status' :
            member[key] = (member[key] == 'Married') and 1 or 0
    member.update(son_daughter)
    return member

def store_member_for_loksabha(member):    
    '''
    Associating the member with his biodata
    '''
    member = clean_loksabha_member(member)
     # extract the winning member of the constituency
    mp_sql_query = '''
    select c.id, max(ec.total_votes) from candidates as c join election_candidates as ec on ec.candidate_id = c.id join constituencies as con on con.id = c.constituency_id where con.name = "%s"
    ''' % member['Constituency from which I am elected']
    cursor.execute(mp_sql_query)
    print mp_sql_query
    candidate_id = cursor.fetchone()[0]
    print candidate_id
    mp_update_query = '''
    update candidates set
    display_name = "%s",
    mothers_name = "%s",
    fathers_name = "%s",
    birth_place = "%s",
    date_of_birth = "%s",
    married = "%s",
    married_on = "%s",
    spouse_name = "%s",
    no_of_children = "%s",
    no_of_sons = "%s",
    no_of_daughters = "%s",
    permanent_address = "%s",
    present_address = "%s",
    qualification = "%s",
    profession = "%s",
    positions_held = "%s",
    activities_achievements_interests = "%s",
    sports_n_recreation = "%s",
    hobbies = "%s",
    travelled = "%s",
    other_info     = "%s",
    party_name = "%s"
    where id = %s
    ''' % ( 
        member['Name'],
        member["Mother's Name"],
        member["Father's Name"],
        member['Birth Place'],
        member['Date of Birth'],
        member['Maritial Status' ],
        member['Date of Marriage'], 
        member['Spouse Name'],
        member['No. of Children' ],
        member['No of Sons'],
        member['No of Daughters'],
        member['Permanent Address'],
        member['Present Address'], 
        member['Educational Qualifications'],
        member['Profession'],
        member['Positions Held '],
        member['Social and Cultural Activities, Literary, Artistic and Scientific Accomplishments and other Special Interests'],
        member['Sports, Clubs, Favourite Pastimes and Recreation'],
        member['Hobbies'],
        member['Countries Visited'],
        member['Other Information'], 
        member['Party Name' ],
        candidate_id
        )
    cursor.execute(mp_update_query)
    associate_house_query  = '''
    insert into candidate_revisions set 
    candidate_id = %s,
    revision_id = 1
    ''' % candidate_id
    cursor.execute(associate_house_query)

word_to_number = {
'one' : 1,
'two' : 2,
'three' : 3,
'four' : 4,
'five' : 5,
'six' : 6,
'seven' : 7,
'eight' : 8,
'nine' : 9
}

def clean_rajyasabha_member(member):
    marriage_n_children = {}
    for key in ['Spouse Name', 'No. of Children']:
        if  key not in member:
            member[key] = ''
    for key in member:
        member[key] = connection.escape_string(member[key].strip())
        if key == 'Date of Birth':
            try:
                member[key] = datetime.strptime( member[key], '%Y-%m-%d')
                member[key] = date(member[key].year, member[key].month, member[key].day)
            except:
                member[key] = None
        elif key == 'Maritial Status' :
            if member['Maritial Status'] and member[key].startswith('Married'):
                status, d = member[key].split('On')
                marriage_n_children['Maritial Status'] = status.strip() == 'Married' and 1 or 0
                try:
                    marriage_n_children['Date of Marriage'] = datetime.strptime( d.strip(), '%d %B %Y')
                except:
                    marriage_n_children['Date of Marriage'] = None
            else:
                marriage_n_children['Date of Marriage'], marriage_n_children['Maritial Status']  = None, None
        elif key == 'No. of Children':
            if member[key]:
                split = member[key].split('daughters')
                if len(split) == 2:
                    marriage_n_children['No of Daughters'] = int(word_to_number[split[0].split(' ')[0].lower()])
                    split = split[:1]
                else:
                    marriage_n_children['No of Daughters'] = 0
                marriage_n_children['No of Sons'] = int(word_to_number[split[0].split(' ')[0].lower()])
                member[key] = marriage_n_children["No of Daughters"] + marriage_n_children['No of Sons']
            else:
                member[key] = marriage_n_children["No of Daughters"] = marriage_n_children['No of Sons'] = 0
    member.update(marriage_n_children)
    return member

states = {}
def state_name_to_id(name):
    if name in ('Nominated', ):
        return None
    if not name in states:
        cursor.execute('select id from states where name = "%s"' % name)
        states[name] = cursor.fetchone()[0]
    return states[name]

def store_member_for_rajyasabha(member):
    member = clean_rajyasabha_member(member)
    mp_update_query = '''
    insert into candidates set
    display_name = "%s",
    mothers_name = "%s",
    fathers_name = "%s",
    birth_place = "%s",
    date_of_birth = "%s",
    married = "%s",
    married_on = "%s",
    spouse_name = "%s",
    no_of_children = "%s",
    no_of_sons = "%s",
    no_of_daughters = "%s",
    permanent_address = "%s",
    present_address = "%s",
    qualification = "%s",
    profession = "%s",
    positions_held = "%s",
    activities_achievements_interests = "%s",
    sports_n_recreation = "%s",
    travelled = "%s",
    other_info     = "%s",
    party_name = "%s",
    state_id = "%s"
    ''' % ( 
        member['Name'],
        member["Mother's Name"],
        member["Father's Name"],
        member['Birth Place'],
        member['Date of Birth'],
        member['Maritial Status' ],
        member['Date of Marriage'], 
        member['Spouse Name'],
        member['No. of Children' ],
        member['No of Sons'],
        member['No of Daughters'],
        member['Permanent Address'],
        member['Present Address'], 
        member['Educational Qualifications'],
        member['Profession'],
        member['Positions Held '],
        member['Social and Cultural Activities, Literary, Artistic and Scientific Accomplishments and other Special Interests'],
        member['Sports, Clubs, Favourite Pastimes and Recreation'],
        member['Countries Visited'],
        member['Other Information'], 
        member['Party Name' ],
        state_name_to_id(member['State Name'])
        )
    cursor.execute(mp_update_query)
    associate_house_query  = '''
    insert into candidate_revisions set 
    candidate_id = %s,
    revision_id = 2
    ''' % connection.insert_id() 
    cursor.execute(associate_house_query)


if __name__ == '__main__':
    print 'Howa'
    for_loksabha = False
    if for_loksabha:
        list_url = 'http://india.gov.in/govt/loksabha.php'
        bio_data_url = 'http://india.gov.in/govt/loksabhampbiodata.php?mpcode=%s'
        member_processor = store_member_for_loksabha
        mp_codes = Parser.extract_mp_codes_from_listing(urllib.urlopen(list_url).read())    
    else:
        list_url = 'http://india.gov.in/govt/rajyasabha.php'
        bio_data_url = 'http://india.gov.in/govt/rajyasabhampbiodata.php?mpcode=%s'
        member_processor = store_member_for_rajyasabha
        mp_codes = Parser.extract_rajyasabha_mp_codes_from_listing(urllib.urlopen(list_url).read())    
    for i, code in enumerate(mp_codes):
        print i
        print '*'*80
        print code
        member_processor(Parser.extract_member(urllib.urlopen(bio_data_url % code).read()))
