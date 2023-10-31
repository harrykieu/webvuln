def calculateWebsiteSafetyRate(website_vulnerabilities):
    """
    Define the CVSS scores for each vulnerability
    """
    vulnerabilities = {
        "sql injection": 8.6,
        "broken authentication": 9.8,
        "sensitive data exposure": 6.5,
        "XML External Entity Injection": 7.5,
        "broken access control": 7.2,
        "Security Misconfiguration": 7.3,
        "Cross-Site Scripting (XSS)": 6.1,
        "Insecure Deserialization": 8.1,
        "Using Components with Known Vulnerabilities": 9.6,
        "Insufficient Logging & Monitoring": 5.3
    }

    total_score = sum(vulnerabilities[vuln]
                      for vuln in website_vulnerabilities)

    total_original_score = 100
    website_safety_rate = (1 - total_score / total_original_score) * 100

    """
    Define the conversion table for severity
    """
    severity_conversion = {
        (0, 39): "Critical",
        (40, 69): "High",
        (70, 89): "Medium",
        (90, 99): "Low",
        (100, 100): "None",
    }

    severity = None
    for (lower, upper), label in severity_conversion.items():
        if lower <= website_safety_rate <= upper:
            severity = label

    return website_safety_rate, severity


website_vulnerabilities = ["sql injection", "broken authentication",
                           "sensitive data exposure", "XML External Entity Injection", "broken access control", "Cross-Site Scripting (XSS)"]
safety_rate, severity = calculateWebsiteSafetyRate(website_vulnerabilities)
print(f"Website Safety Rate: {safety_rate:.1f}")
print(f"Severity: {severity}")
