Feature: Graphql Query Test

Background:
 * url 'https://graphqlzero.almansi.me'

Scenario: simple graphql request
    # note the use of text instead of def since this is NOT json
Given path '/api'
And text query =
"""
    {
      user(id: 1) {
        posts {
          data {
            id
            title
          }
        }
      }
    }
    """
And request { query: '#(query)' }
When method post
Then status 200

    # pretty print the response
* print 'response:', response

    # json-path makes it easy to focus only on the parts you are interested in
    # which is especially useful for graph-ql as responses tend to be heavily nested
    # '$' happens to be a JsonPath-friendly short-cut for the 'response' variable
* match $.data.user.posts.data[0] contains { id: '1' }

    # the '..' wildcard is useful for traversing deeply nested parts of the json
* def posts = $..posts.data[*]
* match posts[1] == { id: '2', title: 'qui est esse' }

Scenario Outline: graphql query from a file and using variables
    # here the query is read from a file
    # note that the 'replace' keyword (not used here) can also be very useful for dynamic query building
Given path '/api'
  And def query = read('./data/user-by-id.graphql')
  And def variables = { id: <userid> }
  And request { query: '#(query)', variables: '#(variables)' }
When method post
Then status 200
# And match response.data.user.address == { geo: { lng: 81.1496, lat: -37.3159 } }
# And match response..username contains 'Bret'
  Examples:
    | userid |
    | 1      |
    | 2      |
