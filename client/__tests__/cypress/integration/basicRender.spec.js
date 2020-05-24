context("Basic screen render and components", () => {
  beforeEach(() => {
    cy.visit("http://localhost:8080");
  });

  describe("Basic Render", () => {
    it("Visit page and redirect to Ribeirão Preto", () => {
      cy.url().should("include", "sp/ribeirao-preto");
      cy.get(".cov-loading").should("be.visible");
    });

    it("Default page components", () => {
      cy.get("header.header > .container > .header__brand").contains(
        "COVID-19"
      );
      cy.get("header.header > .container > .header__title").contains(
        "Ocupação de leitos hospitalares"
      );

      cy.get("footer.footer > .container").contains(
        "Este é um projeto open source. Tenha acesso ao código-fonte na íntegra aqui"
      );
      cy.get("footer.footer > .container > a")
        .should("have.attr", "href", "https://github.com/bildvitta/covid")
        .should("have.attr", "target", "_blank");
    });
  });

  describe("Components Render", () => {
    it("First section - City Selection", () => {
      cy.get(
        "main .cov-section:nth-child(1) .cov-grid-cell--md-full > :nth-child(1) > :nth-child(1) > .typography"
      ).contains("Cidade");
      cy.get("main .cov-section:nth-child(1) .select > select").should(
        "have.value",
        "ribeirao-preto"
      );
    });

    it("First section - Cards Cases", () => {
      cy.get("main .cov-section:nth-child(1) .m-t-lg > .typography").contains(
        "Casos"
      );
      cy.get("main .cov-section:nth-child(1) .typography--subtitle").contains(
        "Atualizado há"
      );
      cy.get(
        "main .cov-section:nth-child(1) .m-t-lg > .cov-grid > :nth-child(1) > .cov-box"
      ).contains("Confirmados");
      cy.get(
        "main .cov-section:nth-child(1) .m-t-lg > .cov-grid > :nth-child(1) > .cov-box"
      ).contains("753");

      cy.get(
        "main .cov-section:nth-child(1) .m-t-lg > .cov-grid > :nth-child(2) > .cov-box"
      ).contains("Óbitos");
      cy.get(
        "main .cov-section:nth-child(1) .m-t-lg > .cov-grid > :nth-child(2) > .cov-box"
      ).contains("269");

      cy.get(
        "main .cov-section:nth-child(1) .m-t-lg > .cov-grid > :nth-child(3) > .cov-box"
      ).contains("Recuperados");
      cy.get(
        "main .cov-section:nth-child(1) .m-t-lg > .cov-grid > :nth-child(3) > .cov-box"
      ).contains("50");
    });

    it("Firs sectionn - Cards Beds", () => {
      cy.get(".m-t-md > .typography--title").contains("Leitos");
      cy.get(".m-t-md > .typography--subtitle").contains("Atualizado há");

      cy.get(".hospitals-header__title > .typography").contains("Hospitais");
      cy.get(".hospitals-header__select .select__display").should(
        "have.value",
        ""
      );

      cy.get(
        ".beds > .cov-grid--align-center > :nth-child(1) > .cov-box .card__header"
      ).contains("UTI");
      cy.get(
        ".beds > .cov-grid--align-center > :nth-child(2) > .cov-box .card__header"
      ).contains("Enfermaria");
      cy.get(
        ".beds > .cov-grid--align-center > :nth-child(3) > .cov-box .card__header"
      ).contains("Respiradores");
    });
  });
});
