from bs4 import BeautifulSoup
import requests



def case_track(state):

	source = requests.get("http://coronavirusapi.com/state/" + state).text
	soup = BeautifulSoup(source, "lxml")

	lst = []

	#body_split 
	body = soup.find("body").text
	body_split = body.split()
	
	#total_cases
	set_point = body_split.index('AvgDeaths/Day*')
	total_cases = body_split[(set_point + 2)]
	
	lst.append(total_cases)
	
	#death_count
	death_count = body_split[(set_point + 3)]
	
	lst.append(death_count)
	
	#test_count
	test_count = body_split[(set_point + 1)]
	
	lst.append(test_count)
	
	lst.append(state)
	
	return lst
	
lst = case_track("CA")

total_cases = lst[0]
death_count = lst[1]
test_count = lst[2]
state = lst[3]

print("total cases in ", state, ":", total_cases)
print("death count in", state, ":", death_count)
print("tested cases in", state, ":", test_count)
