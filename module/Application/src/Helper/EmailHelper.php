<?php
namespace Application\Helper;

use Zend\Mail\Message;
use Zend\Mail\Transport\Smtp;
use Zend\Mail\Transport\SmtpOptions;

class EmailHelper {

    const maxMassMail = 50;
    const massEmailId = '';

    public static function getSmtpTransport(): Smtp {
        $transport = new Smtp();
        $options = new SmtpOptions([
            // 'host' => 'smtp.legacy.office365.com',
            // 'port' => 587,
            // 'connection_class' => 'login',
            // 'connection_config' => [
            //     'username' => 'server@jginepal.com',
            //     'password' => 'P@ssw0rd',
            'host' => 'smtp.office365.com',
            'port' => 587,
            'connection_class' => 'login',
            'connection_config' => [
                'username' => 'asdf@asdfdd.com',
                'password' => 'asdf',
                'ssl' => 'tls',
            ],
        ]);
        $transport->setOptions($options);
        return $transport;
    }

    public static function sendEmail(Message $mail) {
        if ('development' == APPLICATION_ENV || 'staging' == APPLICATION_ENV) {
            return true;
        }
        $transport = self::getSmtpTransport();
        $connectionConfig = $transport->getOptions()->getConnectionConfig();
        $mail->setFrom($connectionConfig['username']);
        $transport->send($mail);
        return true;
    }
}
