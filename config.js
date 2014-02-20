exports.config = {
  debug: true,
  name: 'jQuerg',
  description: 'jQuerg',
  version: '0.1.0',
  // for socket
  serverIp : '127.0.0.1',
  port: 8002, 
  clienturl: 'http://www.jquerg.com:8002',
  // serverIp : '127.0.0.1',
  // clienturl: 'http://localhost:8888',
  // site settings
  site_headers: [
    '<meta name="author" content="Kelvin" />', 
  ],
  host: 'www.jQuerg.com',
  cdn: '/', // http://www.jQuerg.com
  site_logo: '', // default is `name`
  site_navs: [ 
    [ '/about', '关于' ],
  ],
  site_static_host: '', // 静态文件存储域名
  site_enable_search_preview: false, // 开启google search preview
  site_google_search_domain:  'jQuerg.com',  // google search preview中要搜索的域名 

  db: 'mongodb://localhost/jquerg',
  session_secret: 'giccoo_club',
  auth_cookie_name: 'giccoo_club',
  list_count: 20,
  // mail SMTP
  mail_opts: {
    host: 'smtp.126.com',
    port: 25,
    auth: {
      user: 'club@126.com',
      pass: 'club'
    }
  }, 
  //weibo app key
  weibo_key: 10000000,     
  plugins: [ 
  ]
};