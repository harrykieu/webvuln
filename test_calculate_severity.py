from calculate_severity import *
website_vulnerabilities = ["sql injection", "broken authentication",
                           "sensitive data exposure", "XML External Entity Injection", "broken access control", "Cross-Site Scripting (XSS)"]
safety_rate, severity = calculateWebsiteSafetyRate(website_vulnerabilities)
print(f"Website Safety Rate: {safety_rate:.1f}")
print(f"Severity: {severity}")