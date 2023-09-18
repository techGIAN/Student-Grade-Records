import pandas as pd
import numpy as np
import random as rnd
import scipy.stats as ss

# assign parameters
n_students = 250
min_id = 100000000
max_id = 999999999
last_name_file = './meta_data/last_names.csv'
first_name_file = './meta_data/first_names.csv'
min_age = 18
max_age = 30
programs_file = './meta_data/programs.txt'
year_level_probs = [0.06, 0.21, 0.59, 0.14] # arbitrary
email_domains_file = './meta_data/email_domains.txt'
demographic_filename = './data/demographic.csv'

# randomize ids
ids = np.random.randint(min_id, max_id, size=(n_students,))

# curate last names
df_last_names = pd.read_csv(last_name_file)
rand_ix_last_names = list(np.random.randint(0, df_last_names.shape[0]-1, size=(n_students,)))
df_last_names = df_last_names.iloc[rand_ix_last_names]
rand_last_names = list(df_last_names['last_name'])
rand_last_names = [''.join([x[0], x[1:].lower()]) for x in rand_last_names]

# curate first names
df_first_names = pd.read_csv(first_name_file)
first_names_list = list(df_first_names['male']) + list(df_first_names['female'])
rand_ix_first_names = list(np.random.randint(0, len(first_names_list)-1, size=(n_students,)))
rand_first_names = [first_names_list[ix] for ix in rand_ix_first_names]

# curate genders
genders = ['M' if x < len(first_names_list)/2 else 'F' for x in rand_ix_first_names]
gender_ix_o = np.random.randint(len(genders), size=(int(n_students*0.1),))
genders = ['O' if x in gender_ix_o else genders[x] for x in range(len(genders))]

# curate ages
age_range = np.arange(min_age-np.mean([min_age, max_age]), max_age+1-np.mean([min_age, max_age]))
age_range_upper, age_range_lower = age_range + 0.5, age_range - 0.5 
probs = ss.norm.cdf(age_range_upper, scale=3) - ss.norm.cdf(age_range_lower, scale=3)
probs = probs / probs.sum() # normalize the probabilities so their sum is 1
ages = list(np.random.choice(age_range, size=(n_students,), p=probs))
ages = [int(age+np.mean([min_age, max_age])) for age in ages]

# curate programs
all_programs = []
with open(programs_file, 'r') as f:
    lines = f.readlines()
f.close()

for line in lines: 
    program = line.strip()
    all_programs.append(program)

rand_ix_programs = np.random.randint(len(all_programs), size=(n_students,))
programs = [all_programs[x] for x in rand_ix_programs]

# curate year_levels
year_levels = list(np.random.choice([1,2,3,4], size=(n_students,), p=year_level_probs))

# curate phone nums
first_three = list(np.random.randint(100, 999, size=(n_students,)))
middle_three = list(np.random.randint(100, 999, size=(n_students,)))
last_four = list(np.random.randint(1000, 9999, size=(n_students,)))
phone_nums = [' '.join([''.join(['(', str(x), ')']), '-'.join([str(y), str(z)])]) for x,y,z in zip(first_three, middle_three, last_four)]

# curate_emails
all_domains = []
with open(email_domains_file, 'r') as f:
    lines = f.readlines()
f.close()

for line in lines: 
    domain = line.strip()
    all_domains.append(domain)

rand_pr = [0.5] + [0.5/(len(all_domains)-1)] * (len(all_domains)-1)
domains = np.random.choice(all_domains, size=(n_students,), p=rand_pr)
# domains = [all_domains[x] for x in rand_ix_domains]
emails = ['@'.join(['.'.join([x.lower(),y.lower()]), z]) for x,y,z in zip(rand_first_names, rand_last_names, domains)]

# curate CGPA
cgpas = list(np.random.normal(7.5, 0.5, size=(n_students,)))
cgpas = [round(x, 2) for x in cgpas]

df = pd.DataFrame({
    'student_id': ids,
    'first_name': rand_first_names,
    'last_name': rand_last_names,
    'program': programs,
    'year_level': year_levels,
    'email': emails,
    'phone_num' : phone_nums, 
    'gender': genders,
    'age': ages
})

df.to_csv(demographic_filename, index=None)
print('Success! The data has been curated.')