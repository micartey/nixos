// @ts-check
/// <reference path="types-dnscontrol.d.ts" />

var REG_NONE = NewRegistrar("none");
var DSP_CLOUDFLARE = NewDnsProvider("cloudflare");

D(
  "micartey.dev",
  REG_NONE,
  DnsProvider(DSP_CLOUDFLARE),

  DefaultTTL(1),

  // DEFAULT
  ALIAS("@", "node.sirius.micartey.dev."),

  // kvms
  A("node.sirius", "80.75.218.8"),
  A("homepod", "100.72.132.37"),

  // kvm server
  CNAME("artifacts", "node.sirius.micartey.dev."),
  CNAME("cdn", "node.sirius.micartey.dev."),
  CNAME("mango", "node.sirius.micartey.dev."),
  CNAME("n8n", "node.sirius.micartey.dev."),
  CNAME("proxy", "node.sirius.micartey.dev."),
  CNAME("vault", "node.sirius.micartey.dev."),
  CNAME("status", "node.sirius.micartey.dev."),
  CNAME("waka", "node.sirius.micartey.dev."),
  CNAME("code", "node.sirius.micartey.dev."),

  // homepod server
  CNAME("status.homepod", "homepod.micartey.dev."),
  CNAME("n8n.homepod", "homepod.micartey.dev."),
  CNAME("pihole.homepod", "homepod.micartey.dev."),

  // message services
  // CNAME("mattermost", "node.sirius.micartey.dev."),
  CNAME("matrix", "node.sirius.micartey.dev."),

  // minecraft server
  CNAME("cardinal", "node.sirius.micartey.dev."),

  // git
  CNAME("gitlab", "node.sirius.micartey.dev."),
  CNAME("registry", "node.sirius.micartey.dev."),
  CNAME("pages", "node.sirius.micartey.dev."),

  TXT("@", "v=spf1 include:_spf.mx.cloudflare.net ~all"),
);
