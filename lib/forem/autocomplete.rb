module Forem
  module Autocomplete
    def forem_autocomplete(term)
      field = Forem.autocomplete_field
      where("#{field} LIKE ?", "%#{term}%").limit(10).order(field).select(field)
    end

  end
end
