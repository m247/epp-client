module EPP
  module ResponseHelper
    def value_for_xpath(xpath, base = nil, &block)
      values_for_xpath(xpath, base, &block).first
    end
    def values_for_xpath(xpath, base = nil)
      nodes_for_xpath(xpath, base).map do |node|
        if block_given?
          yield node
        else
          case node
          when XML::Node
            node.content.strip
          when XML::Attr
            node.value
          end
        end
      end
    end
    def nodes_for_xpath(xpath, base = nil)
      base ||= @response.data
      base.find(xpath, namespaces)
    end
  end
end
