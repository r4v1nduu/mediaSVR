**Setup:**<br />
Before first run, create all the data/config folders under `ARRPATH` with the correct ownership:<br />
`sudo ./init.sh`<br />
Then: `docker compose up -d`<br />

**qBittorrent:**<br />
Check logs for qbittorrent container: `sudo docker logs qbittorrent`<br />
Admin username and passowrd will be in logs<br />
Now you can go to URL: http://localhost:8080<br />
Go to Tools - Options - WebUI - change the user and password.<br />

**Prowlarr:**<br />
http://localhost:9696<br />
Go to Settings - Download Clients - `+` symbol - Add download client - choose qBittorrent.<br />
Fill the port_id, username and password. For host; might want to change from 'localhost' to IP address or container hostname.<br />
Click little 'Test' button at the bottom before saving to make sure you get a green 'tick'.<br />

**Sonarr:**<br />
http://localhost:8989<br />
Go to Settings - Media Management - Add Root Folder - set your root folder according to the docker compose: `/data/tvshows`.<br />
Go to Settings - Download Clients - click `+` symbol - choose qBittorrent and repeat the steps from Prowlarr.<br />
Go to Settings - General - scroll down to API key - copy - go to Prowlarr - Settings - Apps -click '+' - Sonarr - paste API key. <br />
For host; might want to change from 'localhost' to IP address or container hostname.<br />
Click little 'Test' button at the bottom before saving to make sure you get a green 'tick'.<br />
Then Settings - General - switch to 'show advanced' in top left corner - scroll down to 'Backups' and choose `/data/Backup` according to the docker compose.<br />

**Radarr:**<br />
http://localhost:7878<br />
Go to Settings - Media Management - Add Root Folder - set /data/movies as your root folder <br />
Then Settings- Download clients - click 'plus' symbol, choose qBittorrent etc - basically same steps as for Sonarr<br />
Settings - General - scroll down to API key - copy - go to Prowlarr - add same way as in sonarr<br />
Settings - General - switch to 'show advanced'- Backups - choose /data/Backup folder <br />

**Bazarr:**<br />
http://localhost:6767<br />
Go to Settings - Sonarr - enable and fill in host `sonarr`, port `8989`, and the API key from Sonarr's Settings - General page. Test then Save.<br />
Go to Settings - Radarr - same steps, using host `radarr`, port `7878`, and Radarr's API key.<br />
Go to Settings - Languages - add the subtitle languages you want.<br />
Go to Settings - Providers - add at least one subtitle provider (e.g. OpenSubtitles).<br />
Movies/Series will show up once Sonarr/Radarr are connected and their libraries have synced.<br />

**Jellyfin:**<br />
http://localhost:8096<br />
Add media library in Jellyfin matching folders configured in docker-compose.yml file, so in Jellyfin you should see them as: <br />
/data/Movies <br />
/data/TVShows <br />

**FlareSolverr:**<br />
http://localhost:8191<br />
No UI setup needed by itself; it's used as a proxy to bypass Cloudflare on some indexers.<br />
Go to Prowlarr - Settings - Indexers - Indexer Proxies - `+` symbol - FlareSolverr.<br />
Set Host to `http://flaresolverr:8191/` (container hostname, since both are on the same docker network).<br />
Click 'Test' then 'Save'. Then edit any indexer that needs it and set its Tags to match the proxy tag, or apply it under Indexer Proxies as needed per indexer.<br />

**Seerr:**<br />
http://localhost:5055<br />
On first run, sign in using your Jellyfin server URL (`http://jellyfin:8096`) and credentials.<br />
Go to Settings - Services - Add Radarr/Sonarr Server, using `radarr`/`sonarr` as host (container hostname) and the respective API keys copied from each app's Settings - General page.<br />
Mark one server as default for each type, and match the Root Folder / Quality Profile to what you configured in Radarr/Sonarr.<br />
