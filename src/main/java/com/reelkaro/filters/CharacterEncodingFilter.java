package com.reelkaro.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import java.io.IOException;

/**
 * CharacterEncodingFilter — Forces UTF-8 encoding on all requests and responses.
 *
 * This is critical for supporting Hindi (Devanagari) text entered in forms.
 * Without this filter, multi-byte characters may be garbled.
 */
@WebFilter("/*")
public class CharacterEncodingFilter implements Filter {

    private String encoding = "UTF-8";

    @Override
    public void init(FilterConfig config) throws ServletException {
        String enc = config.getInitParameter("encoding");
        if (enc != null && !enc.isEmpty()) {
            this.encoding = enc;
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // Only set if not already set to avoid overriding multipart form data encoding
        if (request.getCharacterEncoding() == null) {
            request.setCharacterEncoding(encoding);
        }
        response.setCharacterEncoding(encoding);
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
