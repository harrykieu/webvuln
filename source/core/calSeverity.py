def calculateWebsiteSafetyRate(websiteVulns):
    """Calculate the website's safety rate and severity
    :param websiteVulns: A list of vulnerabilities defined in the list vulnerabilities.
    :return: A tuple containing the website safety rate and its severity.
    """
    # Define the CVSS scores for each vulnerability
    vulnerabilities = {
        "SQLi": 8.6,
        "XSS": 6.1,
        "LFI": 8.6,
        "Path Traversal": 5.8,
        "IDOR": 7.5,
        "File Upload": 3.3,
    }

    totalScore = 0

    if not websiteVulns:
        return 100, "None"
    for vuln in websiteVulns:
        totalScore += vulnerabilities.get(vuln["type"], 0)

    totalOriginalScore = 100
    websiteSafetyRate = (1 - (totalScore / totalOriginalScore)) * 100

    # Define the conversion table for severity
    safetyPercent = {
        (40, 69): "High",
        (70, 89): "Medium",
        (90, 99): "Low",
        (100, 100): "None",
    }

    severity = None
    for (lower, upper), label in safetyPercent.items():
        if lower <= websiteSafetyRate <= upper:
            severity = label

    return websiteSafetyRate, severity
