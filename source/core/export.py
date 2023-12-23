import os
import json
import pdfkit
import xml.etree.ElementTree as ET


class ReportGenerator:
    def __init__(self, scanResults, filePath):
        self.scanResults = scanResults
        self.filePath = filePath

    def generateJson(self):
        try:
            fileName = os.path.join(self.filePath, 'report.json')
            with open(fileName, 'w') as f:
                json.dump(self.scanResults, f, indent=4)
            return "Success"
        except Exception as e:
            return f"Failed: {e}"

    def generate_xml(self):
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

            return "Success"
        except Exception as e:
            return f"Failed: {e}"

    def generate_pdf(self):
        try:
            pdf_content = '''
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
                pdf_content += '<h1>WEBVULN REPORT</h1>'
                pdf_content += f'<p>Domain: {result["domain"]}</p>'
                pdf_content += '<h2>Scan Date: </h2>'
                pdf_content += f'<p>{result["scanDate"]}</p>'

                pdf_content += '<h2>Vulnerabilities:</h2>'
                pdf_content += f'<p>Vulnerabilities Detected: {result["numVuln"]}</p>'
                pdf_content += '<ul>'
                for vuln in result['vulnerabilities']:
                    pdf_content += f'<li>{vuln["type"]} ({vuln["severity"]}):'
                    pdf_content += f'<p>Payload: {vuln["payload"]}</p>'

                    log_lines = vuln['logs'].split('\n')
                    pdf_content += '<ul>'
                    for line in log_lines:
                        pdf_content += f'<li>{line}</li>'
                    pdf_content += '</ul>'

                    pdf_content += '</li>'

            pdf_content += '</body></html>'


            fileName = os.path.join(self.filePath, 'report.pdf')
            pdfkit.from_file(pdf_content, fileName)

            return "Success"
        except Exception as e:
            return f"Failed: {e}"
