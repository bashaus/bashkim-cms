export default function caseStudyExtension({ strapi }) {
  const extensionService = strapi.plugin("graphql").service("extension");

  extensionService.use(() => ({
    typeDefs: `
      type Query {
        caseStudyBySlug(slug: String!): CaseStudy
      }
    `,

    resolvers: {
      Query: {
        caseStudyBySlug: {
          resolverOf: "api::case-study.case-study.find",
          resolve: async (parent, args, context) => {
            const { toEntityResponse } = strapi
              .plugin("graphql")
              .service("format").returnTypes;

            const results = await strapi.entityService.findMany(
              "api::case-study.case-study",
              {
                filters: { slug: args.slug },
                populate: ["*"],
              },
            );

            return results[0];
          },
          config: {
            auth: false,
          },
        },
      },
    },

    resolversConfig: {
      "Query.caseStudyBySlug": {
        auth: {
          scope: ["api::case-study.case-study.find"],
        },
      },
    },
  }));
}
