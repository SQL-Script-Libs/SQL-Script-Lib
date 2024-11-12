UPDATE [DBO].[USERINFO] SET NETWORKALIAS = 'dominik.einfalt@gws.ms', NETWORKDOMAIN = 'https://sts.windows.net/', SID = 'S-1-5-20', IDENTITYPROVIDER = 'https://sts.windows.net/' WHERE ID = 'Admin';
UPDATE [DBO].[SYSSERVICECONFIGURATIONSETTING] SET [VALUE] = '31f142f5-df76-4112-80a3-19bce6a47b15' WHERE [NAME] = 'TENANTID' -- gws.ms

-- In web.config TenantID, TenantDomainGUID, AdminPrincipal ändern
-- in axhost AdminPrincipal ändern
