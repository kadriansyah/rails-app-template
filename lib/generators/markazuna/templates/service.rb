<%
    if namespaced?
        generated_class_name = "#{namespace.capitalize}::#{class_name}"
    else
        generated_class_name = "#{class_name}"
    end
%>
class <%= generated_class_name %>Service
    def create_<%= singular_name %>(<%= singular_name %>_form)
        <%= singular_name %>_form.save
    end

    def update_<%= singular_name %>(<%= singular_name %>_form)
        <%= singular_name %>_form.update
    end

    def delete_<%= singular_name %>(id)
        <%= singular_name %> = find_<%= singular_name %>(id)
        <%= singular_name %>.delete
    end

    def find_<%= singular_name %>(id)
        <%= generated_class_name %>.find(id)
    end

    def find_<%= plural_name %>(page = 0)
        <%= generated_class_name %>.page(page)
    end
end
