# 360iDev AR Navigation

An ARKit-CoreLocation based experience for 360iDev 2019.  Directions to the Hyatt (conference) and the various food locations that the conference will go to.

### TODO
- [ ] Instead of "print" or "assertionFailure" - provide user back with error messages
- [ ] Handle messages for unsupported devices
- [ ] Add the Schedule

### Schedule JSON
```bash
curl 'https://360idev.com/wp-admin/admin-ajax.php' \
  -H 'sec-fetch-mode: cors' \
  -H 'origin: https://360idev.com' \
  -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \
  -H 'accept: application/json, text/javascript, */*; q=0.01' \
  -H 'referer: https://360idev.com/schedule/' \
  -H 'authority: 360idev.com' \
  -H 'sec-fetch-site: same-origin' --data 'action=get_schedule&data-timestamp=&data-location=&data-track=' --compressed > /tmp/schedule.json
  
```
