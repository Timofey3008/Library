class PaginateService
  def self.build(model, limit:, page:)
    page ||= 1
    limit ||= model.count
    self.new(model, limit, page)
  end

  def initialize(model, limit, page)
    @model = model
    @limit = limit.to_i
    @page = page.to_i
  end

  def call
    return ServiceResult.new(status: false, message: "Limit can't be less than 1") if @limit < 0

    return ServiceResult.new(status: false, message: "Page can't be less than 1") if @page <= 0

    @model = @model.limit(@limit).offset((@page - 1) * @limit).order(:id)
    ServiceResult.new(status: true, message: "Service Complete", data: @model.to_a)

  rescue => e
    ServiceResult.new(
        status: false,
        exception: e,
        message: e.message
    )
  end
end

# service_result = Csv::Create::BulkAccountsService.new(@campaign, not_connected_csv_list_items).call
#
# if service_result.success?
#   data = service_result.data
# else
#   message = service_result.message
# end