import json
import urllib.request

def lambda_handler(event, context):
    # Get IP from query parameter
    params = event.get("queryStringParameters") or {}
    ip = params.get("ip", "")
    
    if not ip:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "IP address is required"})
        }
    
    # Call free geo API
    url = f"http://ip-api.com/json/{ip}"
    with urllib.request.urlopen(url) as response:
        data = json.loads(response.read().decode())
    
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({
            "ip": ip,
            "country": data.get("country"),
            "city": data.get("city"),
            "latitude": data.get("lat"),
            "longitude": data.get("lon"),
            "timezone": data.get("timezone"),
            "isp": data.get("isp")
        })
    }