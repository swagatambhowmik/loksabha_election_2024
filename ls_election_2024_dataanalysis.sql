use ls_election_24;

select count(*) from constituencywise_details;
select count(*) from constituencywise_results;
select count(*) from partywise_results;
select * from states;
select * from statewise_results;

----Data Analysis

-- total seats
select distinct count(*) as total_seats
from constituencywise_results;

-- total seats avaiable per state
select s.state, count(cr.constituency_name) as total_seats
from constituencywise_results cr
inner join statewise_results sr on cr.parliament_constituency=sr.parliament_constituency
inner join states s on s.state_id=sr.state_id
group by s.state;

-- total seats won by NDA alliance
select * from partywise_results;
select sum(seats_won) as nda_total_seats_won
from partywise_results
where party_name in ('Bharatiya Janata Party - BJP', 'AJSU Party - AJSUP', 'Apna Dal (Soneylal) - ADAL',
	'Asom Gana Parishad - AGP', 'Janata Dal  (Secular) - JD(S)', 'Janata Dal  (United) - JD(U)',
	'Lok Janshakti Party(Ram Vilas) - LJPRV', 'Nationalist Congress Party - NCP', 'Shiv Sena - SHS',
	'Sikkim Krantikari Morcha - SKM', 'Telugu Desam - TDP', 'United People’s Party, Liberal - UPPL',
	'Hindustani Awam Morcha (Secular) - HAMS', 'Janasena Party - JnP', 'Rashtriya Lok Dal - RLD');

select sum(case when party_name in (
	'Bharatiya Janata Party - BJP', 'AJSU Party - AJSUP', 'Apna Dal (Soneylal) - ADAL',
	'Asom Gana Parishad - AGP', 'Janata Dal  (Secular) - JD(S)', 'Janata Dal  (United) - JD(U)',
	'Lok Janshakti Party(Ram Vilas) - LJPRV', 'Nationalist Congress Party - NCP', 'Shiv Sena - SHS',
	'Sikkim Krantikari Morcha - SKM', 'Telugu Desam - TDP', 'United People’s Party, Liberal - UPPL',
	'Hindustani Awam Morcha (Secular) - HAMS', 'Janasena Party - JnP', 'Rashtriya Lok Dal - RLD'
) then [seats_won]
else 0 end) as total_seats_won_NDA
from partywise_results;

-- total seats won by NDA parties

select party_name, sum(seats_won) as total_seats_won_NDA_parties
from partywise_results
where party_name in ('Bharatiya Janata Party - BJP', 'AJSU Party - AJSUP', 'Apna Dal (Soneylal) - ADAL',
	'Asom Gana Parishad - AGP', 'Janata Dal  (Secular) - JD(S)', 'Janata Dal  (United) - JD(U)',
	'Lok Janshakti Party(Ram Vilas) - LJPRV', 'Nationalist Congress Party - NCP', 'Shiv Sena - SHS',
	'Sikkim Krantikari Morcha - SKM', 'Telugu Desam - TDP', 'United People’s Party, Liberal - UPPL',
	'Hindustani Awam Morcha (Secular) - HAMS', 'Janasena Party - JnP', 'Rashtriya Lok Dal - RLD')
group by party_name
order by total_seats_won_NDA_parties desc;

-- total seats won by I.N.D.I.A alliance?

select sum(case when party_name in ('Aam Aadmi Party - AAAP', 'All India Trinamool Congress - AITC',
'Communist Party of India  (Marxist) - CPI(M)', 'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
'Communist Party of India - CPI', 'Dravida Munnetra Kazhagam - DMK', 'Indian National Congress - INC',
'Indian Union Muslim League - IUML', 'Jammu & Kashmir National Conference - JKN', 'Jharkhand Mukti Morcha - JMM',
'Kerala Congress - KEC', 'Marumalarchi Dravida Munnetra Kazhagam - MDMK', 'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
'Rashtriya Janata Dal - RJD', 'Rashtriya Loktantrik Party - RLTP', 'Revolutionary Socialist Party - RSP',
'Samajwadi Party - SP', 'Viduthalai Chiruthaigal Katchi - VCK',
'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT', 'Bharat Adivasi Party - BHRTADVSIP')
then [seats_won] else 0 end) as total_seats
from partywise_results;

-- total seats won by INDIA alliance parties

select party_name, sum(seats_won) as total_seats_won_INDIA_parties
from partywise_results
where party_name in ('Aam Aadmi Party - AAAP', 'All India Trinamool Congress - AITC',
'Communist Party of India  (Marxist) - CPI(M)', 'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
'Communist Party of India - CPI', 'Dravida Munnetra Kazhagam - DMK', 'Indian National Congress - INC',
'Indian Union Muslim League - IUML', 'Jammu & Kashmir National Conference - JKN', 'Jharkhand Mukti Morcha - JMM',
'Kerala Congress - KEC', 'Marumalarchi Dravida Munnetra Kazhagam - MDMK', 'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
'Rashtriya Janata Dal - RJD', 'Rashtriya Loktantrik Party - RLTP', 'Revolutionary Socialist Party - RSP',
'Samajwadi Party - SP', 'Viduthalai Chiruthaigal Katchi - VCK',
'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT', 'Bharat Adivasi Party - BHRTADVSIP')
group by party_name
order by total_seats_won_INDIA_parties desc;

-- add new field in the partywise_results to determine the party allaince as NDA, I.N.D.I.A, or OTHER
alter table partywise_results
add party_alliance varchar(20);

update partywise_results
set party_alliance = 'I.N.D.I.A'
where party_name in ('Aam Aadmi Party - AAAP', 'All India Trinamool Congress - AITC',
'Communist Party of India  (Marxist) - CPI(M)', 'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
'Communist Party of India - CPI', 'Dravida Munnetra Kazhagam - DMK', 'Indian National Congress - INC',
'Indian Union Muslim League - IUML', 'Jammu & Kashmir National Conference - JKN', 'Jharkhand Mukti Morcha - JMM',
'Kerala Congress - KEC', 'Marumalarchi Dravida Munnetra Kazhagam - MDMK', 'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
'Rashtriya Janata Dal - RJD', 'Rashtriya Loktantrik Party - RLTP', 'Revolutionary Socialist Party - RSP',
'Samajwadi Party - SP', 'Viduthalai Chiruthaigal Katchi - VCK',
'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT', 'Bharat Adivasi Party - BHRTADVSIP');

update partywise_results
set party_alliance = 'NDA'
where party_name in ('Bharatiya Janata Party - BJP', 'AJSU Party - AJSUP', 'Apna Dal (Soneylal) - ADAL',
	'Asom Gana Parishad - AGP', 'Janata Dal  (Secular) - JD(S)', 'Janata Dal  (United) - JD(U)',
	'Lok Janshakti Party(Ram Vilas) - LJPRV', 'Nationalist Congress Party - NCP', 'Shiv Sena - SHS',
	'Sikkim Krantikari Morcha - SKM', 'Telugu Desam - TDP', 'United People’s Party, Liberal - UPPL',
	'Hindustani Awam Morcha (Secular) - HAMS', 'Janasena Party - JnP', 'Rashtriya Lok Dal - RLD');

update partywise_results
set party_alliance = 'OTHER'
where party_alliance is null;

-- which alliance party(NDA, INDIA, OTHERS) won the most seats across all the states
/*
party_name	seats_won
NDA			292
INDIA		234
OTHERS		17
*/

select party_alliance, sum(seats_won) as total_seats_won
from partywise_results
group by party_alliance;

select * from partywise_results

-- find the winning candidate's name, their party name, party alliance, total votes, and the
-- margin of victory for a specific state

select s.state, cr.winning_candidate, pr.party_name, pr.party_alliance, cr.total_votes, cr.margin
from constituencywise_results cr
inner join partywise_results pr on cr.party_id=pr.party_id
inner join statewise_results sr on cr.parliament_constituency=sr.parliament_constituency
inner join states s on s.state_id=sr.state_id
where s.state='Tripura';

-- find the winning candidate, their party name and party alliance, total votes
select cr.winning_candidate, sr.trailing_candidate,
		pr.party_name as winning_party,
		pr.party_alliance, cr.total_votes, cr.margin as vote_margin
from constituencywise_results cr
inner join partywise_results pr on cr.party_id=pr.party_id
inner join statewise_results sr on cr.parliament_constituency=sr.parliament_constituency;

--total number of independent candidates who took part in the LS polls
select count(1) as total_indipendent_candidates
from constituencywise_details
where party_name='Independent';

-- which independent candidate has got the maximum vote?
select top 1 candidate_name, total_votes
from constituencywise_details
where party_name='Independent'
order by total_votes desc;

-- top 10 total votes polled by every party?
with total_votes_rnk as (select party_name, sum(total_votes) total_votes_polled
,rank() over(order by sum(total_votes) desc) as rnk
from constituencywise_details
group by party_name)

select top 10 *
from total_votes_rnk;












(select party_name, candidate_name, vote_percentage
,rank() over(partition by party_name order by vote_percentage desc) as rnk
from constituencywise_details)






