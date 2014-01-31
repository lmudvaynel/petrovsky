# encoding: utf-8

class HtmlValidator < ActiveModel::EachValidator

  SINGLETON_TAGS = [
    'area', 'base', 'br', 'col', 'hr', 'command', 'img', 'input', 'link',
    'meta', 'param', 'source'
  ]

  def validate_each(record, attribute, value)
    validity_of_html = validate_html(value)
    if validity_of_html[:status] == :error
      record.errors[attribute] << validity_of_html[:message]
    end
  end

  private

  def tag_name(tag)
    tag.gsub /[<>\/]/, ''
  end

  def validate_html(html)
    # Вырезание комментариев и вычленение из html парных тегов
    html = html.to_s.downcase.gsub(/( <[^>]+?\s*\/\s*> | <!--.*?--> )/x, '')
    tags = html.gsub(/<\/?[a-z][a-z0-9]*\b*[^>]*>/i).to_a
    tags.map! { |tag| tag.gsub(/ \b*[^>]*/, '') }

    # Проверка на корректность вложенности тегов
    stack = []
    tags.each do |tag|
      if tag.include? '/'
        last_opened_tag = tag_name stack.pop.to_s
        last_closed_tag = tag_name tag
        # Следует учитывать, что теги из SINGLETON_TAGS могут иметь, а могут
        # и не иметь закрывающего. То есть валидны будут все эти варианты:
        # <param>, <param />, <param></param>
        while (not last_opened_tag == last_closed_tag) && (SINGLETON_TAGS.include? last_opened_tag)
          last_opened_tag = tag_name stack.pop.to_s
        end
        unless last_opened_tag == last_closed_tag
          message = last_opened_tag.blank? ?
            "лишний закрывающий тег #{last_closed_tag}" :
            "нельзя закрыть тег #{last_opened_tag} тегом #{last_closed_tag}"
          return { status: :error, message: message }
        end
      else
        stack.push tag_name(tag)
      end
    end
    if (stack - SINGLETON_TAGS).any?
      return {
        status:   :error,
        message:  "лишний открывающий тег #{(stack - SINGLETON_TAGS).last}"
      }
    else
      return {
        status:   :success
      }
    end
  end
end
