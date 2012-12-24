static int lex_number(fz_stream *f, pdf_lexbuf *buf, int c)
{
        .....
 
        while (1)
        {
                int c = fz_read_byte(f);
                switch (c)
                {
                case '.':
                        goto loop_after_dot;
                case RANGE_0_9:
                        i = 10*i + c - '0';
                        /* FIXME: Need overflow check here; do we care? */
                        break;
                default:
                        fz_unread_byte(f);
                        /* Fallthrough */
                case EOF:
                        if (neg)
                                i = -i;
                        buf->i = i;
                        return PDF_TOK_INT;
                }
        }
