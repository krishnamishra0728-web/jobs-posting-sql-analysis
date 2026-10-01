import random, csv, datetime
random.seed(42)
fields = {
 "Data & Analytics":["Data Analyst","Junior Data Analyst","Business Analyst","MIS Executive","BI Developer","Data Scientist"],
 "Software Development":["Software Engineer","Frontend Developer","Backend Developer","QA Tester","Full Stack Developer"],
 "Marketing":["Digital Marketing Executive","SEO Specialist","Content Writer","Social Media Manager"],
 "Finance":["Accountant","Financial Analyst","Credit Analyst","Auditor"],
 "Human Resources":["HR Executive","Recruiter","Talent Acquisition Specialist"],
 "Sales":["Sales Executive","Business Development Executive","Account Manager"],
 "Customer Support":["Customer Support Associate","Technical Support Engineer","Process Associate"],
 "Design":["UI/UX Designer","Graphic Designer","Video Editor"],
}
base = {"Data & Analytics":5.5,"Software Development":6.5,"Marketing":3.8,"Finance":4.5,"Human Resources":3.6,"Sales":3.5,"Customer Support":3.0,"Design":4.2}
weights = {"Data & Analytics":18,"Software Development":24,"Marketing":12,"Finance":11,"Human Resources":7,"Sales":13,"Customer Support":10,"Design":5}
cities = [("Bengaluru","Karnataka",20),("Hyderabad","Telangana",14),("Pune","Maharashtra",12),("Mumbai","Maharashtra",11),
          ("Gurugram","Haryana",9),("Noida","Uttar Pradesh",8),("Delhi","Delhi",7),("Chennai","Tamil Nadu",6),("Jaipur","Rajasthan",7),("Kolkata","West Bengal",3),("Indore","Madhya Pradesh",3)]
levels = [("Fresher",35),("Junior (1-3 yrs)",33),("Mid (3-6 yrs)",22),("Senior (6+ yrs)",10)]
lmul = {"Fresher":0.7,"Junior (1-3 yrs)":1.0,"Mid (3-6 yrs)":1.6,"Senior (6+ yrs)":2.5}
skills = {"Data & Analytics":["SQL","Excel","Power BI","Tableau","Python"],
 "Software Development":["Java","Python","JavaScript","React","SQL"],
 "Marketing":["SEO","Google Ads","Content Writing","Analytics"],
 "Finance":["Excel","Tally","Accounting","Financial Modeling"],
 "Human Resources":["Recruitment","Excel","Communication"],
 "Sales":["CRM","Communication","Negotiation"],
 "Customer Support":["Communication","CRM","Problem Solving"],
 "Design":["Figma","Photoshop","Illustrator","Premiere Pro"]}
def pick(pairs):
    return random.choices([p[:-1] if len(p)>2 else p[0] for p in pairs],[p[-1] for p in pairs])[0]
inds=["IT Services","Finance","E-commerce","Healthcare","Education","Manufacturing","Marketing Agency","Startup"]
sizes=["Small (1-200)","Medium (201-2000)","Large (2000+)"]
names=["Nexora","BlueArc","Zenith","Orbit","Vertex","Lumina","Apex","Quanta","Pinnacle","Skyline","Cobalt","Ember","Nimbus","Helix","Aurora","Stratos","Mosaic","Cedar","Falcon","Radiant"]
suffix=["Technologies","Solutions","Systems","Labs","Consulting","Global","Digital","Services"]
companies=[]
used=set()
cid=1
while len(companies)<60:
    n=f"{random.choice(names)} {random.choice(suffix)}"
    if n in used: continue
    used.add(n)
    companies.append((cid,n,random.choice(inds),random.choices(sizes,[40,35,25])[0])); cid+=1
with open("companies.csv","w",newline="") as f:
    w=csv.writer(f); w.writerow(["company_id","company_name","industry","company_size"]); w.writerows(companies)
rows=[]
start=datetime.date(2025,1,1)
for i in range(1,5001):
    fld=random.choices(list(weights),list(weights.values()))[0]
    title=random.choice(fields[fld])
    city,state=pick(cities)
    lvl=random.choices([l[0] for l in levels],[l[1] for l in levels])[0]
    mn=round(base[fld]*lmul[lvl]*random.uniform(0.8,1.1),1)
    mx=round(mn*random.uniform(1.15,1.5),1)
    et=random.choices(["Full-time","Internship","Contract"],[82,10,8])[0]
    if et=="Internship": lvl="Fresher"; mn=round(mn*0.35,1); mx=round(mn*1.3,1)
    wm=random.choices(["On-site","Hybrid","Remote"],[50,32,18])[0]
    d=start+datetime.timedelta(days=random.randint(0,515))
    sk=", ".join(random.sample(skills[fld],min(3,len(skills[fld]))))
    rows.append([i,title,fld,random.choice(companies)[0],city,state,lvl,et,wm,mn,mx,random.randint(1,15),d.isoformat(),sk])
with open("job_postings.csv","w",newline="") as f:
    w=csv.writer(f); w.writerow(["job_id","job_title","field","company_id","city","state","experience_level","employment_type","work_mode","min_salary_lpa","max_salary_lpa","openings","posted_date","skills_required"]); w.writerows(rows)
print(len(rows))
