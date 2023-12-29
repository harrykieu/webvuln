import os
import json
import pdfkit
import xml.etree.ElementTree as ET
import source.core.utils as utils

# TODO: this path will be included in .env
wkhtml_path = pdfkit.configuration(
    wkhtmltopdf="C:/Program Files/wkhtmltopdf/bin/wkhtmltopdf.exe"
)


class ReportGenerator:
    def __init__(self, scanResults, filePath):
        self.scanResults = scanResults
        self.filePath = filePath

    def generateJson(self):
        try:
            fileName = os.path.join(self.filePath, "report.json")
            with open(fileName, "w") as f:
                json.dump(self.scanResults, f, indent=4)
            return True
        except Exception as e:
            utils.log(e)
            return False

    def generateXml(self):
        try:
            root = ET.Element("scanResults")
            for result in self.scanResults:
                domain = ET.SubElement(root, "domain")
                ET.SubElement(domain, "name").text = result["domain"]
                ET.SubElement(domain, "scan_date").text = str(result["scanDate"])

                vulns = ET.SubElement(domain, "vulnerabilities")
                for vuln in result["vulnerabilities"]:
                    v = ET.SubElement(vulns, "vulnerability")
                    ET.SubElement(v, "type").text = vuln["type"]
                    ET.SubElement(v, "severity").text = vuln["severity"]
                    ET.SubElement(v, "payload").text = str(vuln["payload"])
                    ET.SubElement(v, "logs").text = vuln["logs"]

            tree = ET.ElementTree(root)
            fileName = os.path.join(self.filePath, "report.xml")
            tree.write(fileName)

            return True
        except Exception as e:
            utils.log(e)
            return False

    def generatePdf(self):
        try:
            pdfContent = """
            <!DOCTYPE html>
            <html>
            <head>
            <style>
            body {
                background-color: white;
                font-family: Cambria;
            }
            div {
                padding: 10px;
                border: 5px solid black;
                margin: 0;
            }
            </style>
            </head>
            <body>
            """
            for result in self.scanResults:
                pdfContent += "<h1>WEBVULN REPORT</h1>"
                pdfContent += "<h2>Domain:</h2>"
                pdfContent += f'<p>{result["domain"]}</p>'
                pdfContent += "<h2>Scan Date: </h2>"
                pdfContent += f'<p>{result["scanDate"]}</p>'
                pdfContent += "<h2>Vulnerabilities</h2>"
                for vuln in result["vulnerabilities"]:
                    pdfContent += f'<h3>{vuln["type"]} ({vuln["severity"]})</h3>'
                    pdfContent += f'<p>Payload: {vuln["payload"]}</p>'
                    pdfContent += "<div><code>"
                    log_lines = vuln["logs"].split("\n")
                    for line in log_lines:
                        # remove the last blank line
                        if len(line) != 0:
                            pdfContent += f"<p>{line}</p>"
            pdfContent += "</code></body></html>"
            fileName = os.path.join(self.filePath, "report.pdf")
            pdfkit.from_string(pdfContent, fileName, configuration=wkhtml_path)
            return True
        except Exception as e:
            utils.log(e, "ERROR")
            return False
