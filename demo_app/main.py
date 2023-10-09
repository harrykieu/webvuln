<<<<<<< HEAD:demo_app/main.py
import argparse
import json
from scanner import scan_website

def generate_report(results):

  report = {
    "url_scanned": "",  
    "vulnerabilities": []
  }
  
  if results:
    report["url_scanned"] = results[0]["url"]

  for item in results:
    report["vulnerabilities"].append({
      "url": item["url"],
      "vuln_type": item["vuln"]
    })

  # Lưu thành file JSON
  with open("report.json", "w") as f: 
    json.dump(report, f, indent=2)

  return report

def main():

  parser = argparse.ArgumentParser()
  parser.add_argument('-u', '--url', required=True, help='URL to scan')
  args = parser.parse_args()
  url = args.url

  results = scan_website(url)

  print(f"Đã hoàn thành scan {url}, tìm thấy {len(results)} lỗ hổng")

  report = generate_report(results)

  print("Báo cáo đã được tạo thành công")


if __name__ == "__main__":
  main()

=======
import scanner
import sys
import json

if __name__ == "__main__":

  if len(sys.argv) != 2:
      print("Usage: python main.py <url>")
      sys.exit(1)

  url = sys.argv[1]
  print(f"Starting scan on {url}")
  
  sqli_result = scanner.check_sqli(url)  
  xss_result = scanner.check_xss(url)


  # Lưu kết quả vào file report.json
  report = {
      "target": url,
      "SQLi vulnerabilities": sqli_result,
      "XSS vulnerabilities": xss_result
  }
  
  with open("report.json", "w") as f:
      json.dump(report, f, indent=4)

  print("[v] Scan completed, report generated")
>>>>>>> origin/rumblescanweb:source/tools/self_made/main.py
