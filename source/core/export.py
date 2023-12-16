import os
import json
import pdfkit
import xml.etree.ElementTree as ET

class ReportGenerator:
    def __init__(self, scan_results, file_path):
        self.scan_results = scan_results
        self.file_path = file_path

    def generate_json(self):
        file_name = os.path.join(self.file_path, 'report.json')
        with open(file_name, 'w') as f:
            json.dump(self.scan_results, f, indent=4)
        return "Success"

    def generate_xml(self):
        root = ET.Element('scan_results')
        for result in self.scan_results:
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
        file_name = os.path.join(self.file_path, 'report.xml') 
        tree.write(file_name)
        
        return "Success"

    def generate_pdf(self):    
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
        
        for result in self.scan_results:
            pdf_content += f'<h1>WEBVULN REPORT</h1>'
            pdf_content += f'<p>Domain: {result["domain"]}</p>'
            pdf_content += f'<h2>Scan Date: </h2>'
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
        
        file_name = os.path.join(self.file_path, 'report.pdf')
        pdfkit.from_string(pdf_content, file_name)
        
        return "Success"
