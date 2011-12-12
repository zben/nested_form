jQuery ($) ->
  $(document).on 'click', 'form .nested-form.add button', ->
    association = $(this).data('association')

    content = $("##{association}_blueprint").html()
    content = content.replace(new RegExp("new_#{association}", 'g'), "new_#{new Date().getTime()}")

    added = $(content).insertBefore($(this).closest('.nested-form.add'))
    $(this).closest('form').trigger(type: 'nested:added', field: added)

    return false
    

  $(document).on 'click', 'form .nested-form.remove button', ->
    $(this).prev('input[type=hidden]').val(true)

    removed = $(this).closest('.nested-form.inputs').hide()
    $(this).closest('form').trigger(type: 'nested:removed', field: removed)

    return false