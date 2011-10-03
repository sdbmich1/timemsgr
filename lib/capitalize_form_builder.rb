class CapitalizeFormBuilder < ActionView::Helpers::FormBuilder

  def text_field(method, options = {})
    @object || @template_object.instance_variable_get("@#{@object_name}")

    options['value'] = @object.send(method).to_s.capitalize

    @template.send(
      "text_field",
      @object_name,
      method,
      objectify_options(options))
    super
  end

end