module RSqoot
  module Deal

    # Retrieve a list of deals based on the following parameters
    #
    # @param [String] query (Search deals by title, description, fine print, merchant name, provider, and category.)
    # @param [String] location (Limit results to a particular area. We'll resolve whatever you pass us (including an IP address) to coordinates and search near there.)
    # @param [Integer] radius (Measured in miles. Defaults to 10.)
    # @param [Integer] page (Which page of result to return. Default to 1.)
    # @param [Integer] per_page (Number of results to return at once. Defaults to 10.)
    def deals(options={})
      updated_by options
      if deals_not_latest?(options)
        uniq = !!options.delete(:uniq)
        @rsqoot_deals = get('deals', options) || []
        @rsqoot_deals = @rsqoot_deals.deals.map(&:deal) if !@rsqoot_deals.empty?
        @rsqoot_deals = uniq_deals(@rsqoot_deals) if uniq
      end
      @rsqoot_deals
    end

    # Retrieve a deal by id
    #
    def deal(id, options={})
      updated_by options
      if deal_not_latest?(id)
        @rsqoot_deal = get("deals/#{id}", options)
        @rsqoot_deal = @rsqoot_deal.deal if @rsqoot_deal
      end
      @rsqoot_deal
    end

    def impression(deal_id, options={})
      url_generator("deals/#{deal_id}/image", options, require_key = true).first.to_s
    end

    private

    def uniq_deals(deals = [])
      titles = deals.map(&:title).uniq
      titles.map do |title|
        deals.map do |deal|
          if deal.try(:title) == title
            deal
          end
        end.compact.last
      end.flatten
    end

  end
end