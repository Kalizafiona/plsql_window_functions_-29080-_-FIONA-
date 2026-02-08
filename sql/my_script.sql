ECOQUEST ADVENTURES: SQL JOINs & Window Functions
Course: INSY 8311 - Database Development with PL/SQL
Student: KALIZA Fiona | 29080 | Group A
Instructor: Eric Maniraguha
Submission Date: February 08, 2025

📊 Business Problem
1.Business Context
Company: EcoQuest Adventures
Department: Operations and Marketing
Industry: Sustainable Tourism / Experiential Education

2.Data Challenge
Managers struggle to see which hunt themes (e.g., urban recycling vs. wildlife discovery) generate the highest green points per participant and actual environmental impact (trash collected KG), because data is scattered across booking records, post-event logs, and feedback forms.
They also find it hard to identify repeat corporate customers vs. one-time school groups, and to understand why certain hunts have low participant satisfaction despite high eco-impact scores, making it difficult to prioritize profitable and impactful offerings.

3.Expected Outcome
After analysis, the team will decide which 2–3 hunt themes to scale up for the next season (focusing on those with best balance of revenue, repeat bookings, and verified sustainability metrics like average green points + trash collected).
They will also adjust staff assignments and clue difficulty to improve overall customer ratings while maintaining strong environmental outcomes.

Success Criteria
Five Measurable Goals Linked to Window Functions:
1.Top 5 Products Per Region/Quarter→ RANK()
→ Why it matters: Quickly highlights the 5 most successful themes so marketing can prioritize promotion budgets and operations can focus clue design efforts on high-impact formats.
2.Running Monthly Sales Totals→ SUM() OVER (ORDER BY … ROWS UNBOUNDED PRECEDING)
→ Why it matters: Provides a clear year-to-date environmental impact figure that can be used in grant applications, corporate client reports, and website marketing to demonstrate real sustainability results.
3.Month-over-Month Growth Analysis→ LAG() / LEAD()
→ Why it matters: Reveals seasonal growth or decline trends per theme, enabling better forecasting of staffing needs and helping decide whether to expand, modify, or discontinue underperforming seasonal offerings.
4.Customer Quartile Segmentation
→ NTILE(4)
→ Why it matters: Allows targeted loyalty programs—offering premium perks to the top 25% (“Eco Champions”), re-engagement discounts to the bottom 25%, and balanced nurturing for the middle tiers to maximize repeat bookings.
5.Three-Month Moving Average→ AVG() OVER (ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING)
→ Why it matters: Smooths out weekend spikes and weather-related noise so operations can confidently adjust guide schedules and avoid over- or under-staffing popular hunting days.

🗄️ Database Schema
Entity Relationship Diagram


Tables
Customers
Hunts
Clues
Staff
Feedback

AS follow :

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

Part A: SQL JOINs
🔗 SQL JOINs Implementation

1. INNER JOIN
SQL Query


📈 Window Functions Implementation

1. Ranking functions
Example: RANK() – Rank hunt themes by total green points earned (highest first), showing which themes perform best overall.




Business Interpretation
This ranks "Urban Recycling" as the #1 theme by environmental impact (green points), followed by "Wildlife Discovery".
It helps marketing prioritize promotion of top-ranked themes and operations focus clue design on high-performers to maximize sustainability outcomes and customer appeal.

2. Aggregate window functions
Example: SUM() OVER – Calculate running total of green points earned over time (chronological order) to track cumulative impact.



Business Interpretation
The cumulative total shows year-to-date green impact reaching 1670 points by February 2026.
This is useful for grant reports, corporate client pitches, and website impact dashboards to demonstrate ongoing environmental contributions and motivate continued bookings.

3. Navigation functions
Example: LAG() – Compare this hunt's green points to the previous hunt for the same customer (repeat customer trend analysis).



Business Interpretation
For repeat customer "Green School Kigali", the second hunt earned fewer points (320 vs. 450 previously), possibly due to theme difficulty or group size.
This helps operations identify trends in repeat bookings and adjust themes/staffing to maintain or increase impact for loyal customers.

4. Distribution functions
Example: NTILE(4) – Divide all hunts into 4 quartiles based on green points earned (to segment high vs. low impact events).



Business Interpretation
Quartile 1 (top 25%) contains the highest-impact hunt (780 points), while quartile 4 has the lowest (120 points).
This segmentation guides decisions like scaling up high-quartile themes for marketing or investigating/revising low-quartile ones to boost overall sustainability performance.
