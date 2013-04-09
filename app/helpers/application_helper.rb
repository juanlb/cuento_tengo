# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def chequeado?(grupo, id)
    #Si no existe la variable de sesión, devuelve true, sino depende del valor de la variable
    session["#{grupo}_#{id}"].nil? ? true : (session["#{grupo}_#{id}"] == 1 ? true : false)
  end
end
