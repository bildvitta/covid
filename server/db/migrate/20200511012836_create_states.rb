class CreateStates < ActiveRecord::Migration[6.0]
  def migrate(direction)
    super

    if direction == :up
      [["Acre", "AC"],
      ["Alagoas", "AL"],
      ["Amapá", "AP"],
      ["Amazonas", "AM"],
      ["Bahia", "BA"],
      ["Ceará", "CE"],
      ["Distrito Federal", "DF"],
      ["Espírito Santo", "ES"],
      ["Goiás", "GO"],
      ["Maranhão", "MA"],
      ["Mato Grosso", "MT"],
      ["Mato Grosso do Sul", "MS"],
      ["Minas Gerais", "MG"],
      ["Pará", "PA"],
      ["Paraíba", "PB"],
      ["Paraná", "PR"],
      ["Pernambuco", "PE"],
      ["Piauí", "PI"],
      ["Rio de Janeiro", "RJ"],
      ["Rio Grande do Norte", "RN"],
      ["Rio Grande do Sul", "RS"],
      ["Rondônia", "RO"],
      ["Roraima", "RR"],
      ["Santa Catarina", "SC"],
      ["São Paulo", "SP"],
      ["Sergipe", "SE"],
      ["Tocantins", "TO"]].each do |state|
        State.create!(:name => state[0], :prefix => state[1])
      end
    end
  end

  def change
    create_table :states do |t|
      t.string :name
      t.string :slug
      t.string :prefix

      t.timestamps
    end
    add_index :states, :slug, unique: true
  end
end
