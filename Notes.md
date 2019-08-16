# Developer Notes

#### Schedule JSON
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
