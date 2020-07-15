# Aspire Budget - Ruby

[![CI Status](https://github.com/drowze/aspirebudgeting_ruby/workflows/CI/badge.svg)](https://github.com/drowze/aspirebudgeting_ruby)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop-hq/rubocop)
[![codecov](https://codecov.io/gh/Drowze/aspirebudgeting_ruby/branch/master/graph/badge.svg)](https://codecov.io/gh/Drowze/aspirebudgeting_ruby)
[![Maintainability](https://api.codeclimate.com/v1/badges/03531044f88452981597/maintainability)](https://codeclimate.com/github/Drowze/aspirebudgeting_ruby/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/03531044f88452981597/test_coverage)](https://codeclimate.com/github/Drowze/aspirebudgeting_ruby/test_coverage)

This is an independent project implementing a Ruby  for Aspire Budgeting spreadsheets, leveraging from the use of another great gem: `google_drive`.
The idea of this gem is to enable a good API to be easily implemented, allowing more powerful and complex tools to emerge.

If you don't know Aspire Budgeting please refer to: https://aspirebudget.com/

## Installation

```
$ gem install 'aspire_budget'
```

## Usage

Either have an initializer with your config:
```ruby
# Use this method if you plan to work on a single spreadsheet with your application
AspireBudget.configure do |config|
  config.session = GoogleDrive.from_config('path_to_your_credentials.json')
  config.spreadsheet_key = 'YOUR_SPREADSHEET_KEY'
end
```

Or specify the config when initializing a worksheet like below.
```ruby
# Use this method if you plan working with multiple spreadsheets with your application
AspireBudget::Worksheets::Transactions.new(
  session: GoogleDrive.from_config('path_to_your_credentials.json'),
  spreadsheet_key: 'YOUR_SPREADSHEET_KEY'
)
```

List transactions:
```ruby
# or AspireBudget::Worksheets::Transactions.new(...).all
AspireBudget::Worksheets::Transactions.all
=> #[<AspireBudget::Models::Transaction:0x0000564acc1ae088
#    @account="Revolut",
#    @category="Groceries",
#    @date=#<Date: 2020-05-31 ((2459001j,0s,0n),+0s,2299161j)>,
#    @inflow=0.0,
#    @memo="Tesco",
#    @outflow=22.51,
#    @status=:approved>,
#   <AspireBudget::Models::Transaction:0x0000564acc1541a0
#    @account="Revolut",
#    @category="Electric Bill",
#    @date=#<Date: 2020-06-22 ((2459023j,0s,0n),+0s,2299161j)>,
#    @inflow=0.0,
#    @memo="Amazon",
#    @outflow=21.54,
#    @status=:approved>]
```

Insert transaction:
```ruby
# or AspireBudget::Worksheets::Transactions.new(...).all
# you can also pass a Transaction record instead of a hash
AspireBudget::Worksheets::Transactions.insert(date: '25/06/2020', outflow: 10.0, inflow: 12.0, category: 'test', account: 'AIB', memo: 'ruby', status: :pending)
=> #<AspireBudget::Models::Transaction:0x0000564acc1522b0 ... >
```

List category transfers
```ruby
AspireBudget::Worksheets::CategoryTransfers.all
=> [#<AspireBudget::Models::CategoryTransfer:0x0000559501fddab8
#    @amount=46.37,
#    @date=#<Date: 2020-06-29 ((2459030j,0s,0n),+0s,2299161j)>,
#    @from="Available to budget",
#    @to="Lunch / Breakfast out",
#    @memo="Monthly target">,
#   <AspireBudget::Models::CategoryTransfer:0x0000559501fdd810
#    @amount=15.0,
#    @date=#<Date: 2020-06-29 ((2459030j,0s,0n),+0s,2299161j)>,
#    @from="Public Transport",
#    @memo="",
#    @to="Available to budget">]
```

Insert category transfer
```ruby
AspireBudget::Worksheets::CategoryTransfers.insert(amount: 10, date: '25/06/2020', from: 'Available to budget', to: 'Electric Bill', memo: 'test')
=> #<AspireBudget::Models::CategoryTransfer:0x0000264acc1529b0 ... >
```


## Development

todo

## Contributing

Bug reports, feature requests and pull requests are welcome.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
