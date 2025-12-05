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
  A("kvm", "37.114.56.153"),
  A("homepod", "100.72.132.37"),

  // services
  CNAME("artifacts", "node.sirius.micartey.dev."),
  CNAME("cdn", "node.sirius.micartey.dev."),
  CNAME("mango", "node.sirius.micartey.dev."),
  CNAME("n8n", "node.sirius.micartey.dev."),
  CNAME("proxy", "node.sirius.micartey.dev."),
  CNAME("vault", "node.sirius.micartey.dev."),
  CNAME("status", "node.sirius.micartey.dev."),

  // vpn services
  CNAME("status.homepod", "homepod.micartey.dev."),
  CNAME("n8n.homepod", "homepod.micartey.dev."),

  // chat services
  // CNAME("mattermost", "node.sirius.micartey.dev."),
  CNAME("matrix", "node.sirius.micartey.dev."),

  // minecraft server
  CNAME("cardinal", "node.sirius.micartey.dev."),

  // legacy
  CNAME("git", "kvm.micartey.dev."),
  CNAME("license", "kvm.micartey.dev."),

  // new services
  CNAME("gitlab", "node.sirius.micartey.dev."),
  CNAME("registry", "node.sirius.micartey.dev."),
  CNAME("pages", "node.sirius.micartey.dev."),

  // mail
  MX("@", 79, "amir.mx.cloudflare.net."),
  MX("@", 96, "linda.mx.cloudflare.net."),
  MX("@", 15, "isaac.mx.cloudflare.net."),
  TXT(
    "cf2024-1._domainkey",
    '"v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiweykoi+o48IOGuP7GR3X0MOExCUDY/BCRHoWBnh3rChl7WhdyCxW3jgq1daEjPPqoi7sJvdg5hEQVsgVRQP4DcnQDVjGMbASQtrY4WmB1VebF+RPJB2ECPsEDTpeiI5ZyUAwJaVX7r6bznU67g7LvFq35yIo4sdlmtZGV+i0H4cpYH9+3JJ78k" "m4KXwaf9xUJCWF6nxeD+qG6Fyruw1Qlbds2r85U9dkNDVAS3gioCvELryh1TxKGiVTkg4wqHTyHfWsp7KD3WQHYJn0RyfJJu6YEmL77zonn7p2SRMvTMP3ZEXibnC9gz3nnhR6wcYL8Q7zXypKTMD58bTixDSJwIDAQAB"',
  ),
  TXT(
    "_dmarc",
    "v=DMARC1; p=none; rua=mailto:41fef6097d404b4691aa8dcc9bb94f6c@dmarc-reports.cloudflare.net",
  ),
  TXT("@", "v=spf1 include:_spf.mx.cloudflare.net ~all"),
);
