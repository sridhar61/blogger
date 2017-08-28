require 'redis'
require 'json'


$redis = Redis.new({:host => '127.0.0.1', :port => 6379})
records = [
	{id: 1, name: 'Kill Bill', year: 2003},
	{id: 2, name: 'King Kong',year: 2005},
	{id: 3, name: 'Killer Elite',year: 2011},
	{id: 4, name: 'Kilts for Bill',year: 2027},
	{id: 5, name: 'Kill Bill 2',year: 2004},
	{id: 6, name: 'Kids',year: 1995},
	{id: 7, name: 'Kindergarten Cop',year: 1990},
	{id: 8, name: 'The Green Mile',year: 1999},
	{id: 9, name: 'The Dark Knight',year: 2008},
	{id: 10, name: 'The Dark Knight Rises',year: 2012}
]

