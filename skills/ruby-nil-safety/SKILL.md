# Ruby Nil Safety Skill

## Purpose
This skill helps Claude improve Ruby code to prevent `nil` errors by applying appropriate safety patterns based on the context (Rails vs plain Ruby).

## When to Use This Skill
- When reviewing or refactoring Ruby code
- When identifying potential `nil` errors or `NoMethodError` risks
- When asked to "make code safer" or "prevent nil errors"
- When seeing method chains without nil protection
- When conditional logic doesn't account for nil values

## Core Principles

### 1. Context Detection
First, determine if the code is running in a Rails context or plain Ruby:

**Rails indicators:**
- Presence of ActiveRecord models
- Use of Rails helpers (e.g., `blank?`, `present?`, `presence`)
- `config/application.rb` or other Rails-specific files
- Gemfile with `rails` gem

**Plain Ruby indicators:**
- No Rails dependencies
- Standalone Ruby scripts
- Pure Ruby libraries

### 2. Safety Patterns by Context

#### Rails Context

**Use `.presence` for assignments and method chains:**
```ruby
# Before
user = User.find_by(email: email)
name = user.name

# After
user = User.find_by(email: email)
name = user&.name

# Or for chainable nil handling
name = User.find_by(email: email)&.name&.upcase
```

**Use `.present?` for conditionals:**
```ruby
# Before
if user && user.active
  process_user(user)
end

# After
if user.present? && user.active
  process_user(user)
end
```

**Use `.presence` to convert blank values to nil:**
```ruby
# Before
params[:search] = params[:search] if params[:search] && !params[:search].empty?

# After
params[:search] = params[:search].presence
```

#### Plain Ruby Context

**Use `&.` (safe navigation operator) for method calls:**
```ruby
# Before
user = find_user(id)
name = user.name if user

# After
user = find_user(id)
name = user&.name
```

**Use `.nil?` for explicit nil checks:**
```ruby
# Before
if user && user.active?
  process_user(user)
end

# After
if !user.nil? && user.active?
  process_user(user)
end

# Or more idiomatically
unless user.nil?
  process_user(user) if user.active?
end
```

**Use `||` for default values:**
```ruby
# Before
name = user.name if user
name = "Unknown" if name.nil?

# After
name = user&.name || "Unknown"
```

### 3. Common Patterns and Solutions

#### Pattern: Method Chaining
```ruby
# Risky
result = object.method1.method2.method3

# Safe
result = object&.method1&.method2&.method3
```

#### Pattern: Hash Access
```ruby
# Risky
value = hash[:key][:nested]

# Safe (Plain Ruby)
value = hash[:key]&.[](:nested)
# or
value = hash.dig(:key, :nested)

# Safe (Rails)
value = hash.dig(:key, :nested).presence
```

#### Pattern: Array Operations
```ruby
# Risky
first_item = array.first.process

# Safe
first_item = array&.first&.process

# Or with explicit check
first_item = array.first&.process if array&.any?
```

#### Pattern: Conditional Assignment
```ruby
# Before
result = if user
  user.calculate_score
else
  0
end

# After (Plain Ruby)
result = user&.calculate_score || 0

# After (Rails)
result = user&.calculate_score.presence || 0
```

### 4. When NOT to Use Safe Navigation

**Don't use when nil is genuinely an error:**
```ruby
# Bad - hides a real bug
user = User.find(id)  # This should never be nil in this flow
user&.update(name: "New Name")  # If user is nil, we have a bigger problem

# Good - let it raise if nil
user = User.find(id)
user.update(name: "New Name")
```

**Don't overuse in simple conditionals:**
```ruby
# Unnecessary
if user&.present?  # present? already handles nil

# Better
if user.present?
```

## Implementation Checklist

When improving Ruby code for nil safety:

1. **Identify the context** (Rails vs plain Ruby)
2. **Scan for risky patterns:**
   - [ ] Method chains without safety operators
   - [ ] Hash/array access without checks
   - [ ] Conditional logic assuming non-nil values
   - [ ] Assignments that could receive nil

3. **Apply appropriate patterns:**
   - [ ] Use `&.` for method calls on potentially nil objects
   - [ ] Use `.present?` / `.blank?` in Rails conditionals
   - [ ] Use `.presence` in Rails for assignments
   - [ ] Use `.nil?` in plain Ruby conditionals
   - [ ] Use `.dig` for nested hash/array access
   - [ ] Add default values with `||` where appropriate

4. **Preserve semantics:**
   - [ ] Don't hide genuine errors
   - [ ] Maintain original logic flow
   - [ ] Keep code readable and idiomatic

5. **Add comments for complex safety logic:**
   ```ruby
   # Returns nil if user is inactive, allowing caller to handle
   active_user_name = user&.active? ? user.name : nil
   ```

## Examples

### Example 1: Rails Controller Action
```ruby
# Before
def show
  @user = User.find_by(id: params[:id])
  @profile = @user.profile
  @avatar_url = @profile.avatar.url
end

# After
def show
  @user = User.find_by(id: params[:id])
  @profile = @user&.profile
  @avatar_url = @profile&.avatar&.url
  
  # Or handle missing user explicitly
  unless @user.present?
    redirect_to root_path, alert: "User not found"
    return
  end
  
  @profile = @user.profile
  @avatar_url = @profile&.avatar&.url
end
```

### Example 2: Plain Ruby Service Object
```ruby
# Before
class UserProcessor
  def process(user_data)
    user = find_user(user_data[:id])
    email = user.email
    formatted = email.downcase.strip
    send_notification(formatted)
  end
end

# After
class UserProcessor
  def process(user_data)
    user = find_user(user_data[:id])
    return unless user  # Explicit early return
    
    email = user.email
    return unless email  # Email could be nil
    
    formatted = email.downcase.strip
    send_notification(formatted)
  end
  
  # Or with safe navigation
  def process(user_data)
    user = find_user(user_data[:id])
    formatted = user&.email&.downcase&.strip
    send_notification(formatted) if formatted
  end
end
```

### Example 3: Rails Model Method
```ruby
# Before
class User < ApplicationRecord
  def full_address
    [address.street, address.city, address.state].join(", ")
  end
end

# After
class User < ApplicationRecord
  def full_address
    return nil unless address.present?
    
    [address.street, address.city, address.state]
      .compact
      .map(&:presence)
      .compact
      .join(", ")
      .presence
  end
end
```

## Testing Considerations

When applying nil safety improvements, suggest tests for:
- Behavior when objects are nil
- Behavior when nested objects are nil
- Default value behavior
- Edge cases with empty collections

```ruby
# Example test suggestions
describe "#full_address" do
  it "returns nil when user has no address" do
    user = User.new(address: nil)
    expect(user.full_address).to be_nil
  end
  
  it "handles partial address data" do
    address = Address.new(street: "123 Main", city: nil)
    user = User.new(address: address)
    expect(user.full_address).to eq("123 Main")
  end
end
```

## Key Reminders

- **Safe navigation (`&.`) doesn't work with operators** - use explicit checks
- **`presence` returns nil for blank values** - useful for form params
- **`present?` is the opposite of `blank?`** - both handle nil
- **Method chains should fail fast or be fully safe** - pick a strategy
- **Document assumptions** - if nil shouldn't happen, say why

## Questions to Ask

Before applying improvements:
1. Is nil a valid state or an error condition?
2. Should we fail fast or handle gracefully?
3. What's the appropriate default value?
4. Are we in a Rails context with ActiveSupport helpers?
5. Will this change affect the method's return type contract?