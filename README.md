# Aspire Budget - Ruby 

This is an independent project implementing a Ruby  for Aspire Budgeting spreadsheets, leveraging from the use of another great gem: `google_drive`.  
The idea of this gem is to enable a good API to be easily implemented, allowing more powerful and complex tools to emerge.

If you don't know Aspire Budgeting please refer to: https://aspirebudget.com/

## Installation

todo

## Usage

```ruby
session = GoogleDrive::Session.from_config('path_to_your_credentials.json')
client = AspireBudget::Client.new(session: session, spreadsheet_key: 'YOUR_SPREADSHEET_KEY')
```

## Development

todo

## Contributing

Bug reports, feature requests and pull requests are welcome.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
