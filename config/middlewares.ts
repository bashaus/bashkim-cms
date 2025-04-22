import { env } from "@strapi/utils";

const directives = {
  "connect-src": ["'self'", "https:"],
  "img-src": ["'self'", "data:", "blob:"],
  "media-src": ["'self'", "data:", "blob:"],
  upgradeInsecureRequests: null,
};

const S3_ASSETS_BUCKET = env("S3_ASSETS_BUCKET");
const AWS_REGION = env("AWS_REGION");

if (S3_ASSETS_BUCKET && AWS_REGION) {
  const s3Domain = `${S3_ASSETS_BUCKET}.s3.${AWS_REGION}.amazonaws.com`;

  directives["img-src"].push(s3Domain);
  directives["media-src"].push(s3Domain);
}

export default [
  "strapi::logger",
  "strapi::errors",
  {
    name: "strapi::security",
    config: {
      contentSecurityPolicy: {
        useDefaults: true,
        directives,
      },
    },
  },
  "strapi::cors",
  "strapi::poweredBy",
  "strapi::query",
  "strapi::body",
  "strapi::session",
  "strapi::favicon",
  "strapi::public",
];
