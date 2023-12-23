import os
import json
import pdfkit
import xml.etree.ElementTree as ET
import source.core.utils as utils


class ReportGenerator:
    def __init__(self, scanResults, filePath):
        self.scanResults = scanResults
        self.filePath = filePath

    def generateJson(self):
        try:
            fileName = os.path.join(self.filePath, 'report.json')
            with open(fileName, 'w') as f:
                json.dump(self.scanResults, f, indent=4)
            return True
        except Exception as e:
            utils.log(e)
            return False

    def generateXml(self):
        try:
            root = ET.Element('scanResults')
            for result in self.scanResults:
                domain = ET.SubElement(root, 'domain')
                ET.SubElement(domain, 'name').text = result['domain']
                ET.SubElement(domain, 'scan_date').text = str(result['scanDate'])

                vulns = ET.SubElement(domain, 'vulnerabilities')
                for vuln in result['vulnerabilities']:
                    v = ET.SubElement(vulns, 'vulnerability')
                    ET.SubElement(v, 'type').text = vuln['type']
                    ET.SubElement(v, 'severity').text = vuln['severity']
                    ET.SubElement(v, 'payload').text = str(vuln['payload'])
                    ET.SubElement(v, 'logs').text = vuln['logs']

            tree = ET.ElementTree(root)
            fileName = os.path.join(self.filePath, 'report.xml')
            tree.write(fileName)

            return True
        except Exception as e:
            utils.log(e)
            return False

    def generatePdf(self):
        try:
            pdfContent = '''
            <!DOCTYPE html>
            <html>
            <head>
            <style>
            body {
                background-color: white;
                font-family: Cambria;
            }
            </style>
            </head>
            <body>
            '''

            for result in self.scanResults:
                pdfContent += '<h1>WEBVULN REPORT</h1>'
                pdfContent += f'<p>Domain: {result["domain"]}</p>'
                pdfContent += '<h2>Scan Date: </h2>'
                pdfContent += f'<p>{result["scanDate"]}</p>'

                pdfContent += '<h2>Vulnerabilities:</h2>'
                pdfContent += f'<p>Vulnerabilities Detected: {result["numVuln"]}</p>'
                pdfContent += '<ul>'
                for vuln in result['vulnerabilities']:
                    pdfContent += f'<li>{vuln["type"]} ({vuln["severity"]}):'
                    pdfContent += f'<p>Payload: {vuln["payload"]}</p>'

                    log_lines = vuln['logs'].split('\n')
                    pdfContent += '<ul>'
                    for line in log_lines:
                        pdfContent += f'<li>{line}</li>'
                    pdfContent += '</ul>'

                    pdfContent += '</li>'

            pdfContent += '</body></html>'

            fileName = os.path.join(self.filePath, 'report.pdf')
            pdfkit.from_string(pdfContent, fileName)

            return True
        except Exception as e:
            utils.log(e)
            return False
