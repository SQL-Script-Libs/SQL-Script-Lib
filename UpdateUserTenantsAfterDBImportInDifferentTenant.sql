select identityProvider, networkalias, NETWORKDOMAIN, * from UserInfo where name = 'Admin'

-- cavete https://sts.windows.net/ zu https://sts.windows.net/4f06d35e-cdfd-45f9-a1e3-7e554c6dd7fd/
-- gws https://sts.windows.net/31f142f5-df76-4112-80a3-19bce6a47b15/ zu https://sts.windows.net/

--update UserInfo set IDENTITYPROVIDER = 'https://sts.windows.net/4f06d35e-cdfd-45f9-a1e3-7e554c6dd7fd/' where NETWORKALIAS LIKE '%cavete.ms'
--update UserInfo set IDENTITYPROVIDER = 'https://sts.windows.net/' where NETWORKALIAS LIKE '%gws.ms'

--update UserInfo set NETWORKDOMAIN = 'https://sts.windows.net/cavete.ms' where NETWORKALIAS LIKE '%cavete.ms'
--update UserInfo set NETWORKDOMAIN = 'https://sts.windows.net/' where NETWORKALIAS LIKE '%gws.ms'
