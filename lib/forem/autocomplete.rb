module Forem
  module Autocomplete
    def forem_autocomplete(term)
      where("#{Forem.autocomplete_field} LIKE ?", "%#{term}%").
      limit(10).
      select("#{Forem.autocomplete_field}").
      order("#{Forem.autocomplete_field}")
    end

  end
end
