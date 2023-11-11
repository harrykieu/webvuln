def calculateWebsiteSafetyRate(websiteVulns):
    """Calculate the website's safety rate and severity
    :param websiteVulns: A list of vulnerabilities defined in the list vulnerabilities.
    :return: A tuple containing the website safety rate and its severity.
    """
    # Define the CVSS scores for each vulnerability
    # FIX
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
        "Insufficient Logging & Monitoring": 5.3,
        # FIX LATER
        "File Upload": 9.8,
        "Path Traversal": 9.8,
    }

    total_score = 0
    if not websiteVulns:
        return 0, "None"
    for vuln in websiteVulns:
        total_score += vulnerabilities.get(vuln["type"], 0)
    totalScore = 100
    webSafetyRate = (1 - (total_score / totalScore)) * 100

    # Define the conversion table for severity
    severity_conversion = {
        (0, 39): "Critical",
        (40, 69): "High",
        (70, 89): "Medium",
        (90, 99): "Low",
        (100, 100): "None",
    }

    severity = None
    for (lower, upper), label in severity_conversion.items():
        if lower <= webSafetyRate <= upper:
            severity = label
    return webSafetyRate, severity
