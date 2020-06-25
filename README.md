# Aspire Budget - Ruby 

This is an independent project implementing a Ruby  for Aspire Budgeting spreadsheets, leveraging from the use of another great gem: `google_drive`.  
The idea of this gem is to enable a good API to be easily implemented, allowing more powerful and complex tools to emerge.

If you don't know Aspire Budgeting please refer to: https://aspirebudget.com/

## Installation

```
$ gem install 'aspire_budget'
```

## Usage

Initiate client connection:
```ruby
session = GoogleDrive::Session.from_config('path_to_your_credentials.json')
client = AspireBudget::Client.new(session: session, spreadsheet_key: 'YOUR_SPREADSHEET_KEY')
```

List transactions:
```ruby
client.list_transactions
# <AspireBudget::Models::Transaction:0x0000564acc1ae088
#  @account="Revolut",
#  @category="Groceries",
#  @date=#<Date: 2020-05-31 ((2459001j,0s,0n),+0s,2299161j)>,
#  @inflow=0.0,
#  @memo="Tesco",
#  @outflow=22.51,
#  @status=:approved>,
# <AspireBudget::Models::Transaction:0x0000564acc1541a0
#  @account="Revolut",
#  @category="Cosmetics",
#  @date=#<Date: 2020-06-22 ((2459023j,0s,0n),+0s,2299161j)>,
#  @inflow=0.0,
#  @memo="Amazon",
#  @outflow=21.54,
#  @status=:approved>
```

Insert transaction:
```ruby
client.insert_transaction(date: '25/06/2020', outflow: 10.0, inflow: 12.0, category: 'test', account: 'AIB', memo: 'ruby', status: :pending)
=> #<AspireBudget::Models::Transaction:0x0000564acc1522b0
# @account="AIB",
# @category="test",
# @date=#<Date: 2020-06-25 ((2459026j,0s,0n),+0s,2299161j)>,
# @inflow=12.0,
# @memo="ruby",
# @outflow=10.0,
# @status=:pending>
```

## Development

todo

## Contributing

Bug reports, feature requests and pull requests are welcome.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
