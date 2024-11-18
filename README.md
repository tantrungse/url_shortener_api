# ShortLink API

A scalable and secure URL shortening service designed to handle high-volume traffic with robust security measures.

## System Overview

This URL shortening service is built to handle significant scale while maintaining security and performance. The system is designed based on the following assumptions:

### Scale Assumptions
* **Monthly Active Users**: 30M users (estimated at 10% of Twitter's scale)
* **Data Capacity Model**:
  * Long URL: 2KB (2048 chars)
  * Short URL: 17 bytes
  * Created At: 7 bytes
  * Updated At: 7 bytes
  * **Total per record**: 2.031KB
  * **Monthly storage**: ~60.7GB
  * **5-year storage projection**: ~3.6TB

## Security Considerations

### Identified Security Issues and Mitigations

#### 1. **Validation of Original URLs**
- **Issue:** Users may submit invalid or malicious URLs
- **Mitigation:**
  - Validate URL format using `validate_url_of` gem
  - Enforce 2048-character limit
  - Normalize URLs to prevent duplication

#### 2. **Rate Limiting**
- **Issue:** Potential DDoS attacks or system abuse
- **Mitigation:**
  - Implement rate limiting on `/encode` and `/decode` endpoints
  - Return 429 status code when limits are exceeded

#### 3. **Collision Handling**
- **Issue:** Potential short code collisions in high-volume scenarios
- **Mitigation:**
```ruby
def generate_unique_short_code
  loop do
    code = SecureRandom.urlsafe_base64(5)[0, 7]
    break code unless Url.exists?(short_code: code)
  end
end
```

#### 4. **SQL Injection Prevention**
- **Issue:** Potential SQL injection vulnerabilities
- **Mitigation:**
  - Use Active Record's parameterized queries
  - Avoid direct input interpolation

#### 5. **Sensitive Data Protection**
- **Issue:** Exposure of sensitive configuration
- **Mitigation:**
  - Use environment variables
  - Proper `.gitignore` configuration

## Scalability Considerations

### Key Scalability Challenges and Solutions

#### 1. **Sequential ID Generation**
- **Issue:** Single point of failure with sequential IDs
- **Solution:** 
  - Implement distributed ID generation (Snowflake)
  - Use sharded sequences for better distribution

#### 2. **Short Code Generation**
- **Issue:** Predictable patterns in short codes
- **Solution:**
  - Hash sequential IDs before Base62 encoding
  - Implement collision detection and resolution

#### 3. **Data Growth Management**
- **Issue:** Continuous dataset growth
- **Solution:**
  - Implement URL expiration mechanisms
  - Archive inactive URLs
  - Regular data cleanup processes

#### 4. **Distributed System Challenges**
- **Issue:** High concurrency and data consistency
- **Solution:**
  - Database replication
  - Implement sharding strategies
  - Multi-layer caching architecture

## Known Trade-offs and Limitations

### Performance Impact
1. **Short Code Generation**
   - Slight latency increase due to uniqueness validation
   - Higher latency as code space becomes saturated

### Security vs. Performance
1. **Validation Overhead**
   - URL validation adds processing time
   - Rate limiting may impact legitimate high-volume users

### Scalability Limitations
1. **Database Bottlenecks**
   - Central sequence generation can limit write throughput
   - Sharding complexity increases with scale

## Future Improvements

1. **Security Enhancements**
   - Advanced rate-limiting strategies
   - Enhanced threat monitoring and logging
   - Automated security scanning

2. **Scalability Improvements**
   - Implementation of distributed ID generation
   - Advanced caching strategies
   - Automated sharding mechanisms
