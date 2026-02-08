# ECOQUEST ADVENTURES: SQL JOINs & Window Functions
**Course:** INSY 8311 - Database Development with PL/SQL
**Student:** KALIZA Fiona | 29080 | Group A
**Instructor:** Eric Maniraguha
**Submission Date:** February 08, 2025

## 📊 Business Problem
## 1.Business Context
Company: EcoQuest Adventures
Department: Operations and Marketing
Industry: Sustainable Tourism / Experiential Education

## 2.Data Challenge
Managers struggle to see which hunt themes (e.g., urban recycling vs. wildlife discovery) generate the highest green points per participant and actual environmental impact (trash collected KG), because data is scattered across booking records, post-event logs, and feedback forms.
They also find it hard to identify repeat corporate customers vs. one-time school groups, and to understand why certain hunts have low participant satisfaction despite high eco-impact scores, making it difficult to prioritize profitable and impactful offerings.

## 3.Expected Outcome
After analysis, the team will decide which 2–3 hunt themes to scale up for the next season (focusing on those with best balance of revenue, repeat bookings, and verified sustainability metrics like average green points + trash collected).
They will also adjust staff assignments and clue difficulty to improve overall customer ratings while maintaining strong environmental outcomes.

## Success Criteria
Five Measurable Goals Linked to Window Functions:

## 1.Top 5 Products Per Region/Quarter→ RANK()
→ Why it matters: Quickly highlights the 5 most successful themes so marketing can prioritize promotion budgets and operations can focus clue design efforts on high-impact formats.

## 2.Running Monthly Sales Totals→ SUM() OVER (ORDER BY … ROWS UNBOUNDED PRECEDING)
→ Why it matters: Provides a clear year-to-date environmental impact figure that can be used in grant applications, corporate client reports, and website marketing to demonstrate real sustainability results.

## 3.Month-over-Month Growth Analysis→ LAG() / LEAD()
→ Why it matters: Reveals seasonal growth or decline trends per theme, enabling better forecasting of staffing needs and helping decide whether to expand, modify, or discontinue underperforming seasonal offerings.
## 4.Customer Quartile Segmentation
→ NTILE(4)
→ Why it matters: Allows targeted loyalty programs—offering premium perks to the top 25% (“Eco Champions”), re-engagement discounts to the bottom 25%, and balanced nurturing for the middle tiers to maximize repeat bookings.
## 5.Three-Month Moving Average→ AVG() OVER (ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING)
→ Why it matters: Smooths out weekend spikes and weather-related noise so operations can confidently adjust guide schedules and avoid over- or under-staffing popular hunting days.

## 🗄️ Database Schema
Entity Relationship Diagram
<img width="1382" height="752" alt="Untitled" src="https://github.com/user-attachments/assets/0ecff058-f523-411f-bf1d-0a7a452a60fa" />


## Tables
Customers
Hunts
Clues
Staff
Feedback

## AS follow :

Table Customers {
  Customer_ID number [pk]
  Name varchar(100)
  Email varchar(100)
  Phone varchar(20)
  Type varchar(20)
}

Table Hunts {
  Hunt_ID number [pk]
  Customer_ID number [ref: > Customers.Customer_ID]
  Theme varchar(50)
  Location varchar(100)
  Date_Scheduled date
  Participants_Count number
  Green_Points_Earned number
}

Table Clues {
  Clue_ID number [pk]
  Description varchar(500)
  Eco_Impact varchar(200)
  Difficulty_Level varchar(10)
}

Table Hunt_Clues {
  Hunt_ID number [ref: > Hunts.Hunt_ID, pk]
  Clue_ID number [ref: > Clues.Clue_ID, pk]
  Sequence_Order number
}

Table Staff {
  Staff_ID number [pk]
  Name varchar(100)
  Role varchar(50)
  Expertise varchar(100)
}

Table Hunt_Assignments {
  Hunt_ID number [ref: > Hunts.Hunt_ID, pk]
  Staff_ID number [ref: > Staff.Staff_ID, pk]
}

Table Feedback {
  Feedback_ID number [pk]
  Hunt_ID number [ref: > Hunts.Hunt_ID]
  Rating number
  Comments varchar(1000)
  Date_Submitted date
}

## Part A: SQL JOINs
## 🔗 SQL JOINs Implementation

## 1. INNER JOIN
SQL Query
<img width="799" height="214" alt="Screenshot 2026-02-08 141533" src="https://github.com/user-attachments/assets/99164daf-cfce-4c78-9920-d091e4412daf" />

## Result
<img width="531" height="115" alt="Screenshot 2026-02-08 141547" src="https://github.com/user-attachments/assets/17f15a06-11b3-47d6-87ae-d5cb6423443a" />

## Business Interpretation
This result shows only the hunts that received feedback, revealing customer satisfaction levels for completed events. It is useful for identifying which hunts are generating responses (here, mostly high-participant or repeat-customer events) so operations can follow up on low-rated ones like the crowded Urban Recycling hunt to improve future experiences.

## 2.  LEFT JOIN
SQL Query
<img width="610" height="148" alt="Screenshot 2026-02-08 141656" src="https://github.com/user-attachments/assets/14fe4c2f-68f3-467a-8f66-09aa218ed715" />


## Result

<img width="545" height="182" alt="Screenshot 2026-02-08 141706" src="https://github.com/user-attachments/assets/79fae47a-800a-4dd3-a3c2-202dcd43b6ed" />

## Business Interpretation
This shows every booked hunt and highlights that the Wetland Exploration event has no feedback yet (possibly because it is upcoming or participants forgot to submit). It is useful for marketing and operations to proactively send reminders to participants of low- or no-feedback hunts to increase response rates and gather insights for improving niche themes.

## 3. RIGHT JOIN
SQL Query
<img width="659" height="186" alt="Screenshot 2026-02-08 141759" src="https://github.com/user-attachments/assets/66e736ae-c2bb-4925-81e0-7d00ab3c5117" />


## Result
<img width="545" height="156" alt="Screenshot 2026-02-08 141808" src="https://github.com/user-attachments/assets/5d142e1a-51c8-4d1a-81f3-ed23449165c0" />


## Business Interpretation
Since no orphan feedback exists in this small dataset, the result matches the inner join. This query is useful when auditing data integrity (e.g., ensuring no feedback is recorded for non-existent hunts after deletions), helping maintain reliable post-event satisfaction tracking for quality control.

## 4. FULL OUTER JOIN
SQL Query

<img width="468" height="132" alt="Screenshot 2026-02-08 141856" src="https://github.com/user-attachments/assets/f85c3f24-a426-48e5-9ac2-a746d1efeeab" />

## Result
<img width="462" height="159" alt="Screenshot 2026-02-08 141905" src="https://github.com/user-attachments/assets/7d5ceebc-8651-4529-a708-981c2ba69421" />


## Business Interpretation
This complete picture shows hunts without feedback and confirms no stray feedback exists without a hunt. It is valuable for comprehensive reporting to funders or partners, proving all bookings are accounted for and identifying gaps in feedback collection to improve customer engagement processes

## 5. SELF JOIN
SQL Query

<img width="662" height="190" alt="Screenshot 2026-02-08 141958" src="https://github.com/user-attachments/assets/29cca883-5075-424d-b0e7-5d7b6f9b5436" />

## Result
<img width="607" height="147" alt="Screenshot 2026-02-08 142007" src="https://github.com/user-attachments/assets/9f052f76-a364-4619-9c70-63843f3f4054" />


## Business Interpretation
This identifies repeat customers like Green School Kigali, who booked two different themes. It is useful for marketing to target loyalty offers (discounts, priority booking) to schools/corporates with multiple bookings, increasing retention and lifetime value while understanding popular theme combinations.


## 📈 Window Functions Implementation

## 1. Ranking functions
Example: RANK() – Rank hunt themes by total green points earned (highest first), showing which themes perform best overall.
<img width="716" height="194" alt="Screenshot 2026-02-08 142539" src="https://github.com/user-attachments/assets/4b2e1b6b-5a92-466b-a43c-78d343e168a2" />


## Result

<img width="510" height="138" alt="Screenshot 2026-02-08 142546" src="https://github.com/user-attachments/assets/49acdf33-c3a6-4ec6-bc15-55fc9ffbbe67" />

## Business Interpretation
This ranks "Urban Recycling" as the #1 theme by environmental impact (green points), followed by "Wildlife Discovery".
It helps marketing prioritize promotion of top-ranked themes and operations focus clue design on high-performers to maximize sustainability outcomes and customer appeal.

## 2. Aggregate window functions
Example: SUM() OVER – Calculate running total of green points earned over time (chronological order) to track cumulative impact.

<img width="1034" height="224" alt="Screenshot 2026-02-08 142944" src="https://github.com/user-attachments/assets/030c82e7-2cca-4d1b-abee-637e404241c9" />

## Result

<img width="742" height="171" alt="Screenshot 2026-02-08 143001" src="https://github.com/user-attachments/assets/1f576145-f281-4018-8ba6-194158224940" />

## Business Interpretation
The cumulative total shows year-to-date green impact reaching 1670 points by February 2026.
This is useful for grant reports, corporate client pitches, and website impact dashboards to demonstrate ongoing environmental contributions and motivate continued bookings.

## 3. Navigation functions
Example: LAG() – Compare this hunt's green points to the previous hunt for the same customer (repeat customer trend analysis).
<img width="1045" height="196" alt="Screenshot 2026-02-08 162348" src="https://github.com/user-attachments/assets/103c8ecf-b6eb-4c2f-bb49-cec533ff0108" />


## Result
<img width="779" height="199" alt="Screenshot 2026-02-08 162356" src="https://github.com/user-attachments/assets/24df03fe-bf65-435d-90f7-2e7ad96ce487" />


## Business Interpretation
For repeat customer "Green School Kigali", the second hunt earned fewer points (320 vs. 450 previously), possibly due to theme difficulty or group size.
This helps operations identify trends in repeat bookings and adjust themes/staffing to maintain or increase impact for loyal customers.

## 4. Distribution functions
Example: NTILE(4) – Divide all hunts into 4 quartiles based on green points earned (to segment high vs. low impact events).

<img width="573" height="153" alt="Screenshot 2026-02-08 143331" src="https://github.com/user-attachments/assets/bb4da0a1-353e-47a8-aaf4-d8243ae8b15e" />

## Result

<img width="602" height="214" alt="Screenshot 2026-02-08 143342" src="https://github.com/user-attachments/assets/fed72492-414a-4002-821b-b34ac300006c" />

## Business Interpretation
Quartile 1 (top 25%) contains the highest-impact hunt (780 points), while quartile 4 has the lowest (120 points).
This segmentation guides decisions like scaling up high-quartile themes for marketing or investigating/revising low-quartile ones to boost overall sustainability performance.

## 📚 References
### References
- Oracle Analytic Functions: https://docs.oracle.com/en/database/oracle/oracle-database/23/sqlrf/Analytic-Functions.html
- GitHub Creating Repositories: https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository
- Crow's Foot Notation: https://www.vertabelo.com/blog/crows-foot-notation/

  ## ✅ Academic Integrity Statement

All sources were properly cited. Implementations and analysis represent original work. No AI-generated content was copied without attribution or adaptation.

**Signature:** KALIZA Fiona

**Date:** February 08, 2025
## 📧 Contact

**Email:** kalizafiona95@gmail.com
**GitHub:** github.com/Kalizafiona
