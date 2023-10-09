# webvuln
A website vulnerability scanner for coders without any knowledge of web security.
## Technology Stack
- Python 
- Flask (for API - run on localhost)
- MongoDB
- Flutter (for GUI)
- Enumeration tools (dirsearch, ffuf, etc.)
## Use Cases
- Scan a domain/list of domains from input/CSV/JSON file(s)
- See and modify the scan history
- Add/remove payloads and other resources to the database using CSV/JSON file(s)
- Send a notification when the scan is complete
- Analyze using bar/pie charts, click on the chart to show more details
- Choose modules to scan
- Add self-written modules
- Export a report in PDF format
## System Architecture
![Architecture](./assets/architecture.png)
## Database Schema
![Database Schema](./assets/db.png)
## Data Sequence Diagram
### Scan a domain and get results
![Scan](./assets/scan_dsd.png)
### Get scan history
![Get Scan History](./assets/getHistory_dsd.png)
### Get resouces from database
![Get Resources](./assets/getResources_dsd.png)
### Add/remove/update resources to database
![Add/Remove/Update Resources](./assets/postResources_dsd.png)
## Flask Webserver (API for GUI - run on localhost)
![Flask](./assets/api.png)
## Report:
[Here](https://docs.google.com/document/d/1q2712vtjwxAC53eEqRq5TR32uh3Rn8zE73PcZUIBzOs/edit?usp=sharing)