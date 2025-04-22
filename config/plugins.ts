import path from "node:path";

const rootDir = path.join(__dirname, "..", "..");

export default () => ({
  graphql: {
    enabled: true,
    config: {
      endpoint: "/graphql",
      shadowCRUD: true,
      landingPage: false,
      depthLimit: 7,
      amountLimit: 100,
      generateArtifacts: true,
      artifacts: {
        schema: path.join(rootDir, "graphql/schema.gql"),
        typegen: path.join(rootDir, "graphql/types.d.ts"),
      },
      apolloServer: {
        tracing: false,
      },
    },
  },
  oembed: {
    enabled: true,
  },
});
