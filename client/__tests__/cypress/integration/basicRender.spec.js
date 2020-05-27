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
      cy.get("#city-selection h3").contains("Cidade");
      cy.get("#city-selection select").should("have.value", "ribeirao-preto");
    });

    it("First section - Cards Cases", () => {
      cy.get("#cases h3").contains(
        "Casos"
      );
      cy.get("#cases .typography--subtitle").contains(
        "Atualizado há"
      );
      cy.get(
        "#cases :nth-child(1) > .cov-box"
      ).contains("Confirmados");
      cy.get(
        "#cases :nth-child(1) > .cov-box"
      ).contains("753");

      cy.get(
        "#cases :nth-child(2) > .cov-box"
      ).contains("Óbitos");
      cy.get(
        "#cases :nth-child(2) > .cov-box"
      ).contains("269");

      cy.get(
        "#cases :nth-child(3) > .cov-box"
      ).contains("Recuperados");
      cy.get(
        "#cases :nth-child(3) > .cov-box"
      ).contains("50");
    });

    it("Firs section - Cards Beds", () => {
      cy.get(".m-t-md > .typography--title").contains("Leitos");
      cy.get(".m-t-md > .typography--subtitle").contains("Atualizado há");

      cy.get(".hospitals-header__title > .typography").contains("Hospitais");
      cy.get(".hospitals-header__select .select__display").should(
        "have.value",
        ""
      );

      cy.get("#intensive_care_unit .card__header").contains("UTI");
      cy.get("#intensive_care_unit .beds__content:nth-child(1) > .beds__box:nth-child(1) .typography--caption").contains("COVID-19 Ocupação")
      cy.get('#intensive_care_unit .beds__content:nth-child(1) > .beds__box:nth-child(1) .badge').contains("23,81%")
      cy.get('#intensive_care_unit .beds__content:nth-child(1) > .beds__box:nth-child(2) span').contains("Total")
      cy.get('#intensive_care_unit .beds__content:nth-child(1) > .beds__box:nth-child(2) span.typography--weight-bold').contains("21")
      cy.get('#intensive_care_unit .beds__content:nth-child(1) > .beds__box:nth-child(3) span').contains("Ocupados")
      cy.get('#intensive_care_unit .beds__content:nth-child(1) > .beds__box:nth-child(3) span.typography--weight-bold').contains("5")

      cy.get("#intensive_care_unit .beds__content:nth-child(2) .typography--caption").contains("Não COVID-19")
      cy.get('#intensive_care_unit .beds__content:nth-child(2) > .beds__box:nth-child(2) span').contains("Total")
      cy.get('#intensive_care_unit .beds__content:nth-child(2) > .beds__box:nth-child(2) span.typography--weight-bold').contains("31")
      cy.get('#intensive_care_unit .beds__content:nth-child(2) > .beds__box:nth-child(3) span').contains("Ocupados")
      cy.get('#intensive_care_unit .beds__content:nth-child(2) > .beds__box:nth-child(3) span.typography--weight-bold').contains("10")


      cy.get("#nursing .card__header").contains("Enfermaria");
      cy.get("#nursing .beds__content:nth-child(1) > .beds__box:nth-child(1) .typography--caption").contains("COVID-19 Ocupação")
      cy.get('#nursing .beds__content:nth-child(1) > .beds__box:nth-child(1) .badge').contains("15,38%")
      cy.get('#nursing .beds__content:nth-child(1) > .beds__box:nth-child(2) span').contains("Total")
      cy.get('#nursing .beds__content:nth-child(1) > .beds__box:nth-child(2) span.typography--weight-bold').contains("39")
      cy.get('#nursing .beds__content:nth-child(1) > .beds__box:nth-child(3) span').contains("Ocupados")
      cy.get('#nursing .beds__content:nth-child(1) > .beds__box:nth-child(3) span.typography--weight-bold').contains("6")

      cy.get("#nursing .beds__content:nth-child(2) .typography--caption").contains("Não COVID-19")
      cy.get('#nursing .beds__content:nth-child(2) > .beds__box:nth-child(2) span').contains("Total")
      cy.get('#nursing .beds__content:nth-child(2) > .beds__box:nth-child(2) span.typography--weight-bold').contains("78")
      cy.get('#nursing .beds__content:nth-child(2) > .beds__box:nth-child(3) span').contains("Ocupados")
      cy.get('#nursing .beds__content:nth-child(2) > .beds__box:nth-child(3) span.typography--weight-bold').contains("41")

      cy.get("#ventilator .card__header").contains("Respiradores");
      cy.get("#ventilator .beds__content:nth-child(1) > .beds__box:nth-child(1) .typography--caption").contains("COVID-19 Ocupação")
      cy.get('#ventilator .beds__content:nth-child(1) > .beds__box:nth-child(1) .badge').contains("100,00%")
      cy.get('#ventilator .beds__content:nth-child(1) > .beds__box:nth-child(2) span').contains("Total")
      cy.get('#ventilator .beds__content:nth-child(1) > .beds__box:nth-child(2) span.typography--weight-bold').contains("2")
      cy.get('#ventilator .beds__content:nth-child(1) > .beds__box:nth-child(3) span').contains("Ocupados")
      cy.get('#ventilator .beds__content:nth-child(1) > .beds__box:nth-child(3) span.typography--weight-bold').contains("2")

      cy.get("#ventilator .beds__content:nth-child(2) .typography--caption").contains("Não COVID-19")
      cy.get('#ventilator .beds__content:nth-child(2) > .beds__box:nth-child(2) span').contains("Total")
      cy.get('#ventilator .beds__content:nth-child(2) > .beds__box:nth-child(2) span.typography--weight-bold').contains("0")
      cy.get('#ventilator .beds__content:nth-child(2) > .beds__box:nth-child(3) span').contains("Ocupados")
      cy.get('#ventilator .beds__content:nth-child(2) > .beds__box:nth-child(3) span.typography--weight-bold').contains("0")

    });
  });
});
