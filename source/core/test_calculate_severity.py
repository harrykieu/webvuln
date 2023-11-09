from calculate_severity import *
import json
# website_vulnerabilities = ["sql injection", "broken authentication",
#                            "sensitive data exposure", "XML External Entity Injection", "broken access control", "Cross-Site Scripting (XSS)"]
with open('D:\\group_project_year_3\\webvuln\\source\\core\\vulnerabilities.json', 'r') as file:
    data = json.load(file)
    
for website, vulnerabilities in data.items():
    safety_rate, severity = calculateWebsiteSafetyRate(vulnerabilities)
    print(f"Website: {website}")
    print(f"Website Safety Rate: {safety_rate:.1f}")
    print(f"Severity: {severity}")
